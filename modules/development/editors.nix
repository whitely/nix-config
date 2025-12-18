{ config, lib, pkgs, ... }:

{
  # System-wide editor packages
  environment.systemPackages = with pkgs; [
    vim
    kdePackages.kate
  ];
}
