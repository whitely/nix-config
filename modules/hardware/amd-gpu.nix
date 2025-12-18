{ config, lib, pkgs, ... }:

{
  # Enable X server with AMD GPU drivers
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Configure X11 keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
