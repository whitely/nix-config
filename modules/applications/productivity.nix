{ config, lib, pkgs, ... }:

{
  # Productivity applications
  environment.systemPackages = with pkgs; [
    # Cloud storage
    nextcloud-client

    # Compression utilities
    p7zip
    zip

    # File management
    gparted # Partition editor

    # Communication
    signal-desktop
    weechat

    # Torrent client
    deluge

    # System information
    lm_sensors
    htop
    dmidecode
    neofetch
    mesa-demos      # OpenGL utilities
    vulkan-tools    # Vulkan utilities
    pciutils        # lspci and PCI utilities
  ];
}
