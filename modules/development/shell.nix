{ config, lib, pkgs, ... }:

{
  # Enable Fish shell
  programs.fish.enable = true;

  # Enable Bash completion
  programs.bash.enableCompletion = true;
}
