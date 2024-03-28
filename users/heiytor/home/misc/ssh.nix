{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPath = "~/.ssh/controlsocket/%C";
  };
}
