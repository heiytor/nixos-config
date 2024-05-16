{ config, pkgs, inputs, ... }:

{
  virtualisation.docker = {
    enable = true;
    daemon = {
      settings = {
        data-root = "/mnt/extern-1/lib/docker";
      };
    };
  };
}

