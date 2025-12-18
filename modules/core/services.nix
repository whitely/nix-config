{ config, lib, pkgs, ... }:

{
  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable the OpenSSH daemon
  services.openssh.enable = true;

  # Enable GNOME Keyring for credential storage
  services.gnome.gnome-keyring.enable = true;
}
