{ config, lib, pkgs, ... }:

{
  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable the OpenSSH daemon
  services.openssh.enable = true;

  # Enable GNOME Keyring for credential storage
  services.gnome.gnome-keyring.enable = true;

  # Enable NetworkManager for wireless networking
  networking.networkmanager.enable = true;

  # Configure X11 keymap
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    extraPackages = [ pkgs.mesa.drivers ];

    ## radv: an open-source Vulkan driver from freedesktop
    # The default driver, works well with AMD GPUs

    ## amdvlk: an open-source Vulkan driver from AMD
    # Uncomment these lines to use amdvlk instead:
    # extraPackages = [ pkgs.amdvlk ];
    # extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };

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
}
