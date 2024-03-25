{ config, pkgs, ... }:

{
  services.picom = {
    enable = true;
    activeOpacity = 1.0;
    inactiveOpacity = 0.8;
    opacityRules = [
        "90:class_g = 'Alacritty' && focused"
        "80:class_g = 'Alacritty' && !focused"
    ];
  };
}

