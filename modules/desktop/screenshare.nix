{ config, lib, pkgs, ... }:

{
  # Firewall configuration for Avahi/Miracast/Screensharing/Sunshine
  networking.firewall = {
    allowedTCPPorts = [
      7236 7250           # Miracast/gnome-network-displays
      47984 47989 48010   # Sunshine streaming
    ];
    allowedUDPPorts = [
      7236 5353           # Miracast/mDNS
      47998 47999 48000 48010  # Sunshine streaming
    ];
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

  # Sunshine game streaming server (for Steam Deck, mobile devices, etc.)
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;  # Required for proper screen capture and performance
  };

  # Does this link in the readme matter? https://gitlab.gnome.org/GNOME/gnome-network-displays
  # NetworkManager only support P2P operation together with wpa_supplicant.
}
