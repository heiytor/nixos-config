{ config, pkgs, inputs, ... }:

{
  services.xserver = {
    enable = true;
    autorun = true;
    layout = "us";
    xkbVariant = "";
    displayManager = {
      lightdm = {
        enable = true;
      };
      # TODO: remove autoLogin from here 
      defaultSession = "none+awesome";
      autoLogin = {
        enable = true;
        user = "heiytor";
      };
    };
    windowManager = {
      awesome = {
        enable = true;
      };
    };
  };
}

