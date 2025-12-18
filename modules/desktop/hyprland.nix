{ config, lib, pkgs, ... }:

{
  # Enable Hyprland Wayland compositor
  # https://wiki.hyprland.org/Nix/
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };
}
