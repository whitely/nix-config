{ config, lib, pkgs, ... }:

{
  # Development tools and utilities
  environment.systemPackages = with pkgs; [
    # Version control
    git

    # Nix tools
    nurl           # Generate Nix fetcher calls from URLs
    nix-search-cli # Search Nix packages from CLI

    # CLI utilities
    wget
    file
    jq       # JSON processor
    ripgrep  # Fast grep alternative
    fd       # Fast find alternative
    tldr     # Simplified man pages
    fzf      # Fuzzy finder

    # Build tools
    gnupg
    multipath-tools
    parted
    busybox
  ];

  # Enable GPG agent with SSH support
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable MTR (network diagnostic tool)
  programs.mtr.enable = true;
}
