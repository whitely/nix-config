{ pkgs, lib, inputs, ... }:

{
  imports = [
    ../modules/fish.nix
    ../modules/hyprland.nix
    ../modules/dotfiles.nix
    ../modules/virt-manager.nix
    ../modules/xdg.nix
  ];

  # Enable bash (required)
  programs.bash.enable = true;

  home.packages = with pkgs; [
    # Development tools
    direnv
    devenv
    inputs.claude-code.packages.${pkgs.system}.default

    # Gaming/Input utilities
    jstest-gtk
    linuxConsoleTools

    # Graphics editing
    gimp-with-plugins

    # Applications
    chromium
    libreoffice

    # Hardware utilities
    usbutils
    pciutils
  ];

  # Home Manager state version
  home.stateVersion = "24.05";
}
