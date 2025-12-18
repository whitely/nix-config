{ config, lib, pkgs, ... }:

{
  # System packages for emulation
  environment.systemPackages = with pkgs; [
    dolphin-emu  # GameCube/Wii emulator
    appimage-run # For Slippi (SSBM online)
  ];

  # GameCube controller hardware support (commented out, enable if needed)
  # services.udev.packages = [ pkgs.dolphinEmu ];
  # boot.extraModulePackages = [
  #   config.boot.kernelPackages.gcadapter-oc-kmod
  # ];
  #
  # # to autoload at boot:
  # boot.kernelModules = [
  #   "gcadapter_oc"
  # ];

  # Note: Slippi flake available at ~/code/ssbm-nix
  # https://github.com/djanatyn/ssbm-nix
}
