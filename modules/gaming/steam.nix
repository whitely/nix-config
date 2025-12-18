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
}
