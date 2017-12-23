# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Use for BIOS boot
  # boot.loader.grub.device = "/dev/sdb";


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
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Phoenix";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget vim git file
    plasma-nm
    kate yakuake tmux
    
    firefox-bin
    tdesktop weechat
    amarok vlc streamlink
    
    gcc-unwrapped gnumake python
  ];

  # Fish!
  programs.fish.enable = true;

  # Web browser addons
#  pkgs.firefox-bin = {
#    enableGoogleTalkPlugin = true;
#    enableAdobeFlash = true;
#  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Compromise for those juicy frames
  nixpkgs.config.allowUnfree = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Enable PulseAudio
  hardware.pulseaudio.enable = true;

  # Enable VirtualBox
  virtualisation.virtualbox.host.enable = true;
  # Disable hardening to allow 3D acceleration
  virtualisation.virtualbox.host.enableHardening = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  # user Ben
  users.users.ben = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "vboxusers" ];
    shell = pkgs.fish;
  };

  # Define the systemd containers
  # Arch - gaming:
  systemd.nspawn.arch = {
    enable = true;
    execConfig = { Boot = true; };
    filesConfig = {
      Volatile = true; # Will make the OS stateless.
    };
    networkConfig = { VirtualEthernet = true; Port = "tcp:2200:22"; }; # Map localhost:2200 to container:22

  };


  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
