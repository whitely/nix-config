{ config, lib, pkgs, ... }:

{
  # Enable Flatpak
  services.flatpak.enable = true;

  # Add a repo afterwards with:
  # flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}
