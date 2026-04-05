{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Hostname
  networking.hostName = "agave-nix";

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
