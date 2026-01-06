{ config, lib, pkgs, ... }:

{
  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable the OpenSSH daemon
  services.openssh.enable = true;

  # Enable GNOME Keyring for credential storage
  services.gnome.gnome-keyring.enable = true;

  # Enable NetworkManager for wireless networking with P2P support
  networking.networkmanager = {
    enable = true;
    # Commenting out because it made wifi flaky
#     wifi = {
#       backend = "wpa_supplicant";
#       powersave = false;  # Disable power saving for better P2P performance
#     };
  };

  # Additional wpa_supplicant configuration for P2P/Miracast
  # This suggested by Claude
  # Commenting out because it made wifi flaky
#   environment.etc."wpa_supplicant.conf".text = ''
#     ctrl_interface=/var/run/wpa_supplicant
#     ctrl_interface_group=wheel
#     update_config=1
#     p2p_go_intent=15
#     p2p_go_ht40=1
#   '';

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
}
