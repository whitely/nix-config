{ config, lib, pkgs, ... }:

{
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
