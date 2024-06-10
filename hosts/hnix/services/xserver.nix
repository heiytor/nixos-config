{ config, pkgs, inputs, ... }:

{
  services.xserver = {
    enable = true;
    autorun = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    displayManager = {
      lightdm = {
        enable = true;
      };
    };
    windowManager = {
      awesome = {
        enable = true;
      };
    };
  };
  services.displayManager = {
    # TODO: remove autoLogin from here 
    defaultSession = "none+awesome";
    autoLogin = {
      enable = true;
      user = "heiytor";
    };
  };
}

