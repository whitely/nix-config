{ config, lib, pkgs, ... }:

{
  # Desktop utilities and tools
  environment.systemPackages = with pkgs; [
    # Terminal emulator
    kitty
    kdePackages.yakuake

    # Application launcher
    wofi

    # Network management
    kdePackages.plasma-nm
    connman
    networkmanagerapplet

    # Terminal utilities
    tmux
    grc

    # Clipboard tools
    xsel
    xclip

    # Fish plugin
    fishPlugins.fzf

    # KDE utilities
    kdePackages.kwin
    kdePackages.kpipewire

    # Utility applications
    gnome-network-displays
    d-spy
    door-knocker

    # CoolerControl for fan/cooling management
    coolercontrol.coolercontrol-gui
    coolercontrol.coolercontrold
    coolercontrol.coolercontrol-ui-data
    # coolercontrol.coolercontrol-liqctld

    # VM utilities
    samba4Full
    libguestfs
    guestfs-tools
    ncdu # Disk usage analyzer

    # SPICE for VMs
    spice
    spice-protocol
    spice-gtk
    virt-viewer
  ];
}
