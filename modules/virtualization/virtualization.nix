{ config, lib, pkgs, ... }:

{
  # Enable dconf (required for virt-manager to remember settings)
  programs.dconf.enable = true;

  # Enable virt-manager
  programs.virt-manager.enable = true;

  # Enable libvirtd virtualization
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;

      # OVMF settings commented out when switching to unstable
      # ovmf = {
      #   enable = true;
      #   packages = [(pkgs.OVMF.override {
      #     secureBoot = true;
      #     tpmSupport = true;
      #   }).fd];
      # };
    };
  };

  # Enable SPICE USB redirection
  virtualisation.spiceUSBRedirection.enable = true;

  # Virtualization-related packages
  environment.systemPackages = with pkgs; [
    # VM management
    virt-manager
    virt-viewer

    # SPICE for VMs
    spice
    spice-protocol
    spice-gtk

    # File sharing and utilities
    samba4Full
    libguestfs
    guestfs-tools
    ncdu # Disk usage analyzer
  ];
}
