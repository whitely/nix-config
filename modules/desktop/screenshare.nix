{ config, lib, pkgs, ... }:

{
  # Firewall configuration for Avahi/Miracast/Screensharing
  networking.firewall = {
    allowedTCPPorts = [ 7236 7250 ];
    allowedUDPPorts = [ 7236 5353 ];
  };

  # Screenshare and network display utilities
  environment.systemPackages = with pkgs; [
    gnome-network-displays  # Miracast/wireless display
    d-spy                   # D-Bus inspector
    door-knocker            # Port knocking utility
  ];

  # Does this link in the readme matter? https://gitlab.gnome.org/GNOME/gnome-network-displays
  # NetworkManager only support P2P operation together with wpa_supplicant.
}
