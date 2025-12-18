{ config, lib, pkgs, ... }:

{
  # Enable ratbagd for gaming mouse configuration
  services.ratbagd.enable = true;
  # `ratbagctl list` to get device cute names, e.g. "singing-gundi" for my mouse
  # `ratbagctl singing-gundi button 6 action set macro KEY_F8` to set macro
  # Can also interact with `piper` GUI tool

  # Enable OpenRGB for RGB peripheral control
  services.hardware.openrgb.enable = true;

  # Note: hardware.sensors service doesn't exist in current NixOS
  # Sensor monitoring can be done via lm_sensors package
}
