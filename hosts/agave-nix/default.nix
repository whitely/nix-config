{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Hostname
  networking.hostName = "agave-nix";

  # This is in an attempt to make BattlEye work on Linux for GTAV Online (private sessions only)
  # https://steamcommunity.com/sharedfiles/filedetails/?id=3658540317
  networking.extraHosts = ''
    0.0.0.0 paradise-s1.battleye.com
    0.0.0.0 test-s1.battleye.com
    0.0.0.0 paradiseenhanced-s1.battleye.com
  '';

  # Define user account
  users.users.ben = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "Ben";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "gamemode" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  # Runtime GPU passthrough (unbind/rebind without reboot)
  vfio.runtime.enable = true;

  # The state version determines the NixOS release from which the default
  # settings for stateful data were taken. Don't change this unless upgrading.
  system.stateVersion = "24.05";
}
