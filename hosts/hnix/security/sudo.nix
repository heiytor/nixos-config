{ config, pkgs, inputs, ... }:

{
  security.sudo = {
    wheelNeedsPassword = false;
  }
}
