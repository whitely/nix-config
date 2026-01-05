{ config, lib, pkgs, ... }:

{
  # Bootloader - Use systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel modules
  boot.kernelModules = [ "v4l2loopback" ];

  # Include the kernel modules necessary for mounting /
  boot.initrd.kernelModules = [
    "sata_nv"
    "ext4"
  ] ++ lib.optionals (!config.vfio.enable) [
    # Only load amdgpu in initrd when NOT using VFIO
    # (vfio.nix loads it after VFIO modules when VFIO is enabled)
    "amdgpu"
  ];

  # IOMMU for GPU passthrough
  # https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/
  boot.kernelParams = [ "amd_iommu=on" ];

  # VFIO specialisation for GPU passthrough
  specialisation."VFIO".configuration = {
    system.nixos.tags = [ "with-vfio" ];
    vfio.enable = true;
  };
}
