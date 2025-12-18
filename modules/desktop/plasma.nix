{ config, lib, pkgs, ... }:

{
  # Enable SDDM display manager
  services.displayManager.sddm.enable = true;

  # Enable KDE Plasma 6 desktop environment
  services.desktopManager.plasma6.enable = true;
}
