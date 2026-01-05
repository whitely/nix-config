{ config, lib, pkgs, ... }:

{
  # Enable Fish shell
  programs.fish.enable = true;

  # Enable Bash completion
  programs.bash.enableCompletion = true;

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
