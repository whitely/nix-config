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

  # AppImage support
  programs.appimage.binfmt = true; # Allow direct running of appimage

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };
}
