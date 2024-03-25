{ config, pkgs, inputs, ... }:

{
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse = {
      enable = true;
    };
    jack = {
      enable = true;
    };
  };

  # Recommended
  security.rtkit = {
    enable = true;
  };
}

