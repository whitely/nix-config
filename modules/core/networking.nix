{ config, lib, pkgs, ... }:

{
  # Enable NetworkManager for wireless networking
  networking.networkmanager.enable = true;

  # Firewall configuration
  networking.firewall = {
    allowedTCPPorts = [ 7236 7250 ];
    allowedUDPPorts = [ 7236 5353 ];
  };
}
