# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdc";
  boot.loader.grub.useOSProber = true;

  # Use the systemd-boot EFI boot loader.
#   boot.loader.systemd-boot.enable = true;
#   boot.loader.efi.canTouchEfiVariables = true;


  # Include the kernel modules necessary for mounting /

  boot.initrd.kernelModules = [
    "sata_nv"
    "ext4"
  ];

  networking.hostName = "ben-nixDesktop"; # Define your hostname.
  # Use networkmanager instead of wpa_supplicant
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Enables wireless via networkmanager.

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };


  # Set your time zone.
  time.timeZone = "America/Phoenix";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget vim git file
    plasma-nm gparted
    kate yakuake tmux
    p7zip
    
#     firefox-bin
    tdesktop weechat
    amarok vlc streamlink
#     gksu
#     truecrypt
    
    gcc-unwrapped gnumake
    python3

    # For image-boostrap
    gnupg multipath-tools parted busybox

    # For mounting exFAT SD cards, etc.
#     exfat fuse_exfat exfat-utils

    # For use with PulseAudio
#     gstreamer

    lm_sensors
  ];

  # Fish!
  programs.fish.enable = true;
  programs.firefox.enable = true;


  # Web browser addons
#  pkgs.firefox-bin = {
#    enableGoogleTalkPlugin = true;
#    enableAdobeFlash = true;
#  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Compromise for those juicy frames
  nixpkgs.config.allowUnfree = true;

  # Enable VirtualBox
#   virtualisation.virtualbox.host.enable = true;
#   # Disable hardening to allow 3D acceleration
#   virtualisation.virtualbox.host.enableHardening = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  # user Ben
  users.users.ben = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "Ben";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };


  # Define the systemd containers
  # Arch - gaming:
#   systemd.nspawn.arch = {
#     enable = true;
#     execConfig = { Boot = true; };
#     filesConfig = {
#       Volatile = true; # Will make the OS stateless.
#     };
#     networkConfig = { VirtualEthernet = true; Port = "tcp:2200:22"; }; # Map localhost:2200 to container:22
#
#   };



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
