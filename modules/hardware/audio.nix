{ config, lib, pkgs, ... }:

{
  # Disable PulseAudio in favor of PipeWire
  hardware.pulseaudio.enable = false;

  # Enable RTKit for realtime scheduling
  security.rtkit.enable = true;

  # Enable PipeWire for audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    wireplumber = {
      enable = true;
      configPackages = [];
    };

    # Uncomment if you want to use JACK applications
    # jack.enable = true;
  };
}
