{ config, pkgs, inputs, ... }:

{
  # Workaround fix for nm-online-service from stalling on Wireguard interface.
  # Refs: https://github.com/NixOS/nixpkgs/issues/180175
  systemd.network.wait-online.enable = false;

  services.zerotierone = {
    enable = true;
  };
}
