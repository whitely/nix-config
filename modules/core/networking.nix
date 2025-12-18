{ config, lib, pkgs, ... }:

{
  # Enable NetworkManager for wireless networking
  networking.networkmanager.enable = true;
}
