{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Compromise for those juicy frames
  nixpkgs.config.allowUnfree = true;

  # Optional: auto-optimize the Nix store
  nix.settings.auto-optimise-store = true;

  # Optional: automatic garbage collection
  # nix.gc = {
  #   automatic = true;
  #   dates = "weekly";
  #   options = "--delete-older-than 30d";
  # };
}
