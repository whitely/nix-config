{ config, lib, pkgs, ... }:

{
  # Enable SDDM display manager
  services.displayManager.sddm.enable = true;

  # Enable KDE Plasma 6 desktop environment
  services.desktopManager.plasma6.enable = true;

  # Desktop utilities and tools
  environment.systemPackages = with pkgs; [
    # Terminal emulator
    kdePackages.yakuake

    # Application launcher
    wofi

    # Network management
    kdePackages.plasma-nm
    connman
    # networkmanagerapplet # I was using this for Hyprland, but it resulted in two network management utilities in KDE, which was annoying

    # KDE utilities
    kdePackages.kwin
    kdePackages.kpipewire

    # CoolerControl for fan/cooling management
    coolercontrol.coolercontrol-gui
    coolercontrol.coolercontrold
    coolercontrol.coolercontrol-ui-data
    # coolercontrol.coolercontrol-liqctld
  ];
}
