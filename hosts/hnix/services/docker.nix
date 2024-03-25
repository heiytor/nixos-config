{ config, pkgs, inputs, ... }:

{
  virtualisation.docker = {
    enable = true;
    daemon = {
      settings = {
        data-root = "/mount/extern-1/lib/docker";
      };
    };
  };
}

