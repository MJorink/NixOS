# PipeWire with the PulseAudio API (browser). No ALSA/JACK layers.
{
  flake.modules.nixos.audio = {
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = false;
      jack.enable = false;
      wireplumber.enable = true;
    };
  };
}
