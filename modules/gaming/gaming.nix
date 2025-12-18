{ config, lib, pkgs, ... }:

{
  # Enable gamemode
  programs.gamemode.enable = true;

  # Enable Steam with gamemode integration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports for Steam Local Network Game Transfers

    gamescopeSession.enable = true; # Display upscaling

    # If all the text is tiny, run steam this way:
    # GDK_SCALE=2 steam

    # See https://nixos.wiki/wiki/Steam#Changing_the_driver_on_AMD_GPUs

    # Gamemode settings
    # Make sure you edit each game's launch command to be `gamemoderun %command%`!
    # https://nixos.wiki/wiki/Gamemode
    package = pkgs.steam.override {
      extraPkgs = (pkgs: with pkgs; [
        gamemode
        # additional packages...
        # e.g. some games require python3
      ]);
      # extraLibraries = pkgs: [ pkgs.gperftools ];
      # - Automatically enable gamemode whenever Steam is running
      # -- NOTE: Assumes that a working system install of gamemode already exists!
      extraProfile = let gmLib = "${lib.getLib(pkgs.gamemode)}/lib"; in ''
        export LD_LIBRARY_PATH="${gmLib}:$LD_LIBRARY_PATH"
      '';
    };
  };

  # Gaming-related packages
  environment.systemPackages = with pkgs; [
    # Emulators
    dolphin-emu  # GameCube/Wii emulator
    appimage-run # For Slippi (SSBM online)

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

  # GameCube controller hardware support (commented out, enable if needed)
  # services.udev.packages = [ pkgs.dolphinEmu ];
  # boot.extraModulePackages = [
  #   config.boot.kernelPackages.gcadapter-oc-kmod
  # ];
  #
  # # to autoload at boot:
  # boot.kernelModules = [
  #   "gcadapter_oc"
  # ];

  # Note: Slippi flake available at ~/code/ssbm-nix
  # https://github.com/djanatyn/ssbm-nix
}
