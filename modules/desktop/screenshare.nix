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

  # Enable Avahi mDNS/DNS-SD for local network service discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
      addresses = true;
    };
  };

  # Does this link in the readme matter? https://gitlab.gnome.org/GNOME/gnome-network-displays
  # NetworkManager only support P2P operation together with wpa_supplicant.
}
