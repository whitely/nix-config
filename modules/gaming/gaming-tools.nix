{ config, lib, pkgs, ... }:

{
  # Gaming-related tools and applications
  environment.systemPackages = with pkgs; [
    # Communication
    discord        # Voice chat (links may not open in FF, Krisp won't work)
    discord-canary # Canary version with better Wayland screenshare support

    # Streaming and recording
    obs-studio # Open Broadcaster Software for streaming/recording

    # Gaming peripherals
    piper        # Gaming mouse configuration GUI (works with ratbagd)
    libratbag    # Gaming mouse library

    # Event viewers for debugging input
    wev           # Wayland event viewer
    xorg.xev      # X11 event viewer

    # Notifications
    mako          # Notification daemon for Discord notifications on Wayland

    # Monitoring and debugging
    steam-run     # Run non-NixOS binaries in a FHS-like environment
    inotify-tools # For finding config files, e.g., watching for Elite Dangerous changes

    # Additional utilities
    quickemu # Simple VM manager
  ];
}
