# Runtime GPU passthrough - unbind/rebind without reboot
# Works with the Raphael iGPU as primary display, detaches 7900 XTX on demand
#
# Usage:
#   sudo gpu-vm-start [vm-name]  # Bind GPU, launch VM (default: win10-vfio)
#   sudo gpu-vm-stop [vm-name]   # Graceful shutdown, return GPU to host
#
# Note: RDNA3 reset support is improved in kernel 6.12+ but not guaranteed.
# If rebind fails, a reboot will be required.

{ config, lib, pkgs, ... }:

let
  cfg = config.vfio.runtime;

  gpuPciId = "0000:03:00.0";
  audioPciId = "0000:03:00.1";
  gpuVendorIds = "1002:744c";
  audioVendorIds = "1002:ab30";
  defaultVm = "win10-vfio";
  shutdownTimeout = 120;  # seconds to wait for graceful shutdown
  virshUri = "qemu:///system";

  # Script to start VM with GPU passthrough
  gpuVmStart = pkgs.writeShellScriptBin "gpu-vm-start" ''
    set -euo pipefail

    VIRSH="virsh -c ${virshUri}"
    VM_NAME="''${1:-${defaultVm}}"

    echo "=== Starting VM '$VM_NAME' with GPU passthrough ==="

    # Check if VM exists
    if ! $VIRSH dominfo "$VM_NAME" &>/dev/null; then
      echo "ERROR: VM '$VM_NAME' not found. Available VMs:"
      $VIRSH list --all --name
      exit 1
    fi

    # Check if VM is already running
    if $VIRSH domstate "$VM_NAME" 2>/dev/null | grep -q "running"; then
      echo "VM '$VM_NAME' is already running"
      exit 0
    fi

    # Check current GPU driver
    if [ -e /sys/bus/pci/devices/${gpuPciId}/driver ]; then
      current_driver=$(basename $(readlink /sys/bus/pci/devices/${gpuPciId}/driver))
      echo "Current GPU driver: $current_driver"
    else
      current_driver="none"
    fi

    # Bind GPU to vfio-pci if not already
    if [ "$current_driver" != "vfio-pci" ]; then
      echo "Binding GPU to vfio-pci..."

      # Ensure vfio-pci module is loaded
      modprobe vfio-pci

      # Unbind GPU from amdgpu
      if [ -e /sys/bus/pci/devices/${gpuPciId}/driver ]; then
        echo "${gpuPciId}" > /sys/bus/pci/devices/${gpuPciId}/driver/unbind || true
      fi

      # Unbind audio from snd_hda_intel
      if [ -e /sys/bus/pci/devices/${audioPciId}/driver ]; then
        echo "${audioPciId}" > /sys/bus/pci/devices/${audioPciId}/driver/unbind || true
      fi

      sleep 0.5

      # Bind to vfio-pci
      echo "${gpuVendorIds}" > /sys/bus/pci/drivers/vfio-pci/new_id 2>/dev/null || true
      echo "${gpuPciId}" > /sys/bus/pci/drivers/vfio-pci/bind 2>/dev/null || true
      echo "${audioVendorIds}" > /sys/bus/pci/drivers/vfio-pci/new_id 2>/dev/null || true
      echo "${audioPciId}" > /sys/bus/pci/drivers/vfio-pci/bind 2>/dev/null || true

      echo "GPU bound to vfio-pci"
    fi

    # Start the VM
    echo "Launching VM..."
    $VIRSH start "$VM_NAME"

    echo "=== VM '$VM_NAME' started ==="
    echo "To stop: sudo gpu-vm-stop $VM_NAME"
  '';

  # Script to stop VM and return GPU to host
  gpuVmStop = pkgs.writeShellScriptBin "gpu-vm-stop" ''
    set -euo pipefail

    VIRSH="virsh -c ${virshUri}"
    VM_NAME="''${1:-${defaultVm}}"
    TIMEOUT=${toString shutdownTimeout}
    FORCE="''${2:-}"

    echo "=== Stopping VM '$VM_NAME' and returning GPU to host ==="

    # Check if VM is running
    if ! $VIRSH domstate "$VM_NAME" 2>/dev/null | grep -q "running"; then
      echo "VM '$VM_NAME' is not running, skipping shutdown"
    else
      # Send ACPI shutdown signal (graceful)
      echo "Sending shutdown signal to VM..."
      $VIRSH shutdown "$VM_NAME"

      # Wait for VM to shut down
      echo "Waiting for VM to shut down (timeout: ''${TIMEOUT}s)..."
      elapsed=0
      while $VIRSH domstate "$VM_NAME" 2>/dev/null | grep -q "running"; do
        if [ $elapsed -ge $TIMEOUT ]; then
          echo "WARNING: VM did not shut down within ''${TIMEOUT}s"
          if [ "$FORCE" = "--force" ]; then
            echo "Force destroying VM..."
            $VIRSH destroy "$VM_NAME"
          else
            echo "Use 'sudo gpu-vm-stop $VM_NAME --force' to force kill"
            exit 1
          fi
          break
        fi
        sleep 2
        elapsed=$((elapsed + 2))
        echo "  ... waiting ($elapsed/''${TIMEOUT}s)"
      done

      echo "VM shut down successfully"
    fi

    sleep 1

    # Return GPU to host
    echo "Returning GPU to host..."

    # Check current state
    if [ -e /sys/bus/pci/devices/${gpuPciId}/driver ]; then
      current_driver=$(basename $(readlink /sys/bus/pci/devices/${gpuPciId}/driver))
      if [ "$current_driver" = "amdgpu" ]; then
        echo "GPU already bound to amdgpu"
        echo "=== Done ==="
        exit 0
      fi
    fi

    # Unbind from vfio-pci
    if [ -e /sys/bus/pci/drivers/vfio-pci/${gpuPciId} ]; then
      echo "${gpuPciId}" > /sys/bus/pci/drivers/vfio-pci/unbind || true
    fi
    if [ -e /sys/bus/pci/drivers/vfio-pci/${audioPciId} ]; then
      echo "${audioPciId}" > /sys/bus/pci/drivers/vfio-pci/unbind || true
    fi

    # Remove device IDs from vfio-pci
    echo "${gpuVendorIds}" > /sys/bus/pci/drivers/vfio-pci/remove_id 2>/dev/null || true
    echo "${audioVendorIds}" > /sys/bus/pci/drivers/vfio-pci/remove_id 2>/dev/null || true

    sleep 0.5

    # Trigger PCI rescan to let amdgpu claim the device
    echo "Triggering PCI rescan..."
    echo 1 > /sys/bus/pci/devices/${gpuPciId}/rescan 2>/dev/null || true
    echo 1 > /sys/bus/pci/rescan

    sleep 1

    # Verify
    if [ -e /sys/bus/pci/devices/${gpuPciId}/driver ]; then
      new_driver=$(basename $(readlink /sys/bus/pci/devices/${gpuPciId}/driver))
      echo "GPU now bound to: $new_driver"
      if [ "$new_driver" = "amdgpu" ]; then
        echo "=== GPU successfully returned to host ==="
      else
        echo "WARNING: GPU bound to unexpected driver. Reboot may be required."
        exit 1
      fi
    else
      echo "WARNING: GPU has no driver. Attempting manual bind..."
      echo "${gpuPciId}" > /sys/bus/pci/drivers/amdgpu/bind 2>/dev/null || {
        echo "ERROR: Failed to bind GPU to amdgpu. Reboot required."
        exit 1
      }
    fi
  '';

in {
  options.vfio.runtime = {
    enable = lib.mkEnableOption "Runtime GPU passthrough scripts (unbind/rebind without reboot)";
  };

  config = lib.mkIf cfg.enable {
    # Ensure base virtualization and IOMMU are configured
    # (these should already be set by your existing config)
    boot.kernelParams = lib.mkDefault [ "amd_iommu=on" ];
    boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" ];

    # Install the passthrough scripts
    environment.systemPackages = [
      gpuVmStart
      gpuVmStop
    ];

    # Allow libvirtd group members to run these specific scripts without password
    security.sudo.extraRules = [
      {
        groups = [ "libvirtd" ];
        commands = [
          { command = "${gpuVmStart}/bin/gpu-vm-start"; options = [ "NOPASSWD" ]; }
          { command = "${gpuVmStop}/bin/gpu-vm-stop"; options = [ "NOPASSWD" ]; }
        ];
      }
    ];
  };
}
