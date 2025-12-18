{ config, lib, pkgs, ... }:

{
  # Programming languages and compilers
  environment.systemPackages = with pkgs; [
    python3
    gcc-unwrapped
    gnumake
  ];

  # Enable Java system-wide
  programs.java.enable = true;
}
