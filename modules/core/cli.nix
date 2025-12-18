{ config, lib, pkgs, ... }:

{
  # CLI tools and terminal utilities
  environment.systemPackages = with pkgs; [
    # Terminal emulator
    kitty

    # Terminal utilities
    tmux
    grc

    # Clipboard tools
    xsel
    xclip

    # Fish plugin
    fishPlugins.fzf
  ];
}
