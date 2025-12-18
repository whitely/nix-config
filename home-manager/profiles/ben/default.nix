{ pkgs, lib, ... }:

{
  imports = [
    ../../modules/fish.nix
    ../../modules/hyprland.nix
    ../../modules/dotfiles.nix
    ../../modules/virt-manager.nix
    ../../modules/xdg.nix
    ./packages.nix
  ];

  # Enable bash (required)
  programs.bash.enable = true;

  # Home Manager state version
  home.stateVersion = "24.05";
}
