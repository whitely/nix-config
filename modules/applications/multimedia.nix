{ config, lib, pkgs, ... }:

{
  # Multimedia applications
  environment.systemPackages = with pkgs; [
    # Video players
    vlc
    streamlink

    # Music players
    amarok

    # Video production
    ffmpeg-full

    # Audio control
    pavucontrol # PulseAudio/PipeWire volume control
  ];
}
