{ config, lib, pkgs, ... }:

{
  # Enable GNOME Keyring for credential storage
  services.gnome.gnome-keyring.enable = true;
}
