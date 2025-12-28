# VFIO Troubleshooting - 2025-12-27

## Problem Summary

VFIO GPU passthrough stopped working after upgrading from NixOS 24.05 to unstable (26.05).

**Critical Context:**
- **NO configuration changes** were made between generations
- The ONLY change was switching from channel 24.05 → unstable (26.05)
- This is an **upstream breaking change** in the Linux kernel, not a configuration issue

**Affected Generations:**
- Generation 158 (NixOS 24.05, kernel 6.6.68): VFIO working ✓
- Generation 159+ (NixOS 26.05, kernel 6.12.62): VFIO broken ✗

**Expected behavior:**
- Boot VFIO specialization → GPU DisplayPort output terminates
- Start Windows VM → DisplayPort resumes with Windows

**Actual behavior:**
- Boot VFIO specialization → DisplayPort still works (GPU not released)
- Start Windows VM → DisplayPort freezes

## Hardware Configuration

- **Discrete GPU:** AMD Radeon RX 7900 XTX (PCI 03:00.0)
  - Video: `1002:744c`
  - Audio: `1002:ab30`
  - Should use: `vfio-pci` driver in VFIO mode

- **Integrated GPU:** AMD Raphael (PCI 12:00.0)
  - ID: `1002:164e`
  - Should use: `amdgpu` driver (for host display)

## Root Cause: Linux Kernel 6.0+ Breaking Change

**The real issue:** Since Linux kernel 6.0, the `vfio-pci.ids=` kernel parameter alone is no longer sufficient to bind devices to vfio-pci.

### What Changed in Kernel 6.0+

From kernel 6.0 onwards:
1. **Kernel parameters are read too late** - `vfio-pci.ids` must be embedded in initramfs
2. **Driver binding race condition** - `amdgpu` module loads and binds before `vfio-pci` can claim devices
3. **New requirement** - Must use `modprobe.d` configuration with `softdep` to enforce load order

### Evidence (Generation 159 - After Config Changes)

**Test date:** 2025-12-27
**System:** Booted into VFIO specialization after applying commits 853c885 and previous

```bash
# GPU driver binding - FAILED
$ lspci -nnk | grep -A 3 "1002:744c"
03:00.0 VGA compatible controller [0300]: ... [1002:744c]
  Kernel driver in use: amdgpu  ← WRONG! Should be vfio-pci
```

```bash
# Kernel parameters - PRESENT but NOT WORKING
$ cat /proc/cmdline
... amd_iommu=on amd_iommu=on vfio-pci.ids=1002:744c,1002:ab30 ...
```

```bash
# Driver override - NOT SET
$ cat /sys/bus/pci/devices/0000:03:00.0/driver_override
(null)
```

```bash
# Module load status
$ lsmod | grep -E "vfio|amdgpu"
amdgpu              15749120  82   ← Loaded AND bound to GPU
vfio_pci               16384  0   ← Loaded but NOT bound
vfio_pci_core          98304  1 vfio_pci
vfio                   77824  4 vfio_pci_core,vfio_iommu_type1,vfio_pci
vfio_iommu_type1       53248  0
```

**Conclusion:** The kernel parameters are correctly set, modules are loaded in the intended order, but `amdgpu` still binds to the GPU because the kernel parameter mechanism is insufficient in kernel 6.0+.

## First Fix Attempt (FAILED)

**Commits:** 853c885, previous commits
**Approach:** Module load order and conditional configuration

### Changes Made

**1. modules/virtualization/vfio.nix** - Conditional config:
```nix
config = lib.mkIf config.vfio.enable {
  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
    "amdgpu"  # After VFIO modules
  ];
  boot.kernelParams = [
    "amd_iommu=on"
    ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs)
  ];
};
```

**2. modules/core/boot.nix** - Conditional amdgpu loading:
```nix
boot.initrd.kernelModules = [
  "sata_nv"
  "ext4"
] ++ lib.optionals (!config.vfio.enable) [
  "amdgpu"  # Only when VFIO disabled
];
```

### Why This Failed

This approach assumed the problem was module load order in the configuration, but:
- The configuration hadn't changed between working (24.05) and broken (26.05) generations
- Kernel 6.0+ requires `modprobe.d` configuration, not just parameter/module ordering
- The `vfio-pci.ids` kernel parameter is processed too late in modern kernels

## Required Solution: modprobe.d Configuration

Based on kernel 6.0+ behavior and community solutions, the proper fix requires:

### 1. Add modprobe.d softdep configuration

```nix
# In modules/virtualization/vfio.nix
config = lib.mkIf config.vfio.enable {
  boot.extraModprobeConfig = ''
    softdep amdgpu pre: vfio-pci
    options vfio-pci ids=1002:744c,1002:ab30
  '';

  # ... rest of config
};
```

This ensures:
- `vfio-pci` module loads BEFORE `amdgpu` (softdep)
- Device IDs are configured via modprobe options (alternative to kernel param)
- Configuration is embedded in initramfs where it's read early enough

### 2. Keep existing initrd module order

```nix
boot.initrd.kernelModules = [
  "vfio_pci"
  "vfio"
  "vfio_iommu_type1"
  "amdgpu"
];
```

### 3. Keep IOMMU kernel parameter

```nix
boot.kernelParams = [ "amd_iommu=on" ];
```

Note: `vfio-pci.ids=` can be removed as it's now redundant with modprobe options.

## Alternative Approaches

If `softdep` doesn't work, other kernel 6.0+ compatible solutions:

**Option A: Driver override at boot**
```nix
boot.initrd.postDeviceCommands = ''
  echo vfio-pci > /sys/bus/pci/devices/0000:03:00.0/driver_override
  echo vfio-pci > /sys/bus/pci/devices/0000:03:00.1/driver_override
'';
```

**Option B: Blacklist amdgpu, manual load**
```nix
boot.blacklistedKernelModules = [ "amdgpu" ];
boot.initrd.postDeviceCommands = ''
  modprobe vfio-pci
  modprobe amdgpu
'';
```

## Multi-Host Compatibility

Current solution maintains compatibility:
- Hosts without VFIO: `config.vfio.enable = false` → modprobe config not applied
- Hosts with VFIO enabled: `config.vfio.enable = true` → softdep enforced
- No host-specific configuration required

## Testing & Verification

After implementing modprobe.d fix:

```bash
sudo nixos-rebuild boot
reboot
```

**Boot into VFIO specialization and verify:**

1. Check discrete GPU driver binding:
```bash
lspci -nnk | grep -A 3 "1002:744c"
```
Should show: `Kernel driver in use: vfio-pci`

2. Check module dependencies:
```bash
modprobe --show-depends amdgpu
```
Should list vfio-pci as a dependency

3. Check driver override:
```bash
cat /sys/bus/pci/devices/0000:03:00.0/driver_override
```

4. Expected behavior:
   - DisplayPort output from discrete GPU goes black on boot
   - Switch to integrated GPU (motherboard HDMI) for host
   - Start Windows VM → discrete GPU DisplayPort resumes with Windows

## Related Files

- `modules/virtualization/vfio.nix` - VFIO module configuration (needs modprobe.d fix)
- `modules/virtualization/virtualization.nix` - libvirt/virt-manager setup
- `modules/core/boot.nix` - Boot configuration and VFIO specialization definition
- `hosts/agave-nix/default.nix` - Host-specific configuration

## References

- [Boot stucks when adding vfio-pci IDs - Arch Forums](https://bbs.archlinux.org/viewtopic.php?id=280512)
- [QEMU vfio drivers not binding to GPU - Arch Forums](https://bbs.archlinux.org/viewtopic.php?id=274494)
- [VFIO Passthrough - Boot Stuck Loading Drivers - Arch Forums](https://bbs.archlinux.org/viewtopic.php?id=290283)
- [PCI passthrough via OVMF - ArchWiki](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF)
- [Linux Kernel 6 vfio_pci incompatibility - Level1Techs](https://forum.level1techs.com/t/linux-kernel-6-seems-to-be-incompatible-with-the-vfio-pci-module-needed-for-pci-passthrough/190039)
- [Kernel 6.8 VFIO PCI passthrough issues - Proxmox](https://forum.proxmox.com/threads/kernel-6-8-12-12-pve-update-results-in-vfio-pci-passthrough-issues.168519/)

## Implementation Status

**IMPLEMENTED** - 2025-12-27

The modprobe.d fix has been applied to `modules/virtualization/vfio.nix`:
- Added `boot.extraModprobeConfig` with `softdep amdgpu pre: vfio-pci`
- Added `options vfio-pci ids=1002:744c,1002:ab30` to modprobe config
- Removed redundant `vfio-pci.ids=` kernel parameter (superseded by modprobe options)
- Removed redundant `amd_iommu=on` from vfio.nix (already in boot.nix)

**Next step:** Build and test
```bash
sudo nixos-rebuild boot
reboot
# Select "NixOS - with-vfio" from boot menu
```

## Timeline

- **2025-12-27**: Identified upstream kernel 6.0+ breaking change
  - Tested first fix attempt (module ordering) - FAILED
  - Collected evidence showing `vfio-pci.ids` parameter ignored
  - Documented required solution using `modprobe.d` softdep configuration
  - Implemented modprobe.d fix in vfio.nix
