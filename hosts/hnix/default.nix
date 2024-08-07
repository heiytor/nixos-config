{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix

      ./security/sudo.nix
      ./services/cron.nix
      ./services/docker.nix
      ./services/pipewire.nix
      ./services/xserver.nix
      ./services/ssh.nix
      ./services/udev.nix
      ./services/zerotier.nix
      ./services/teleport.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "23.11";

  networking.hostName = "hnix";
  networking.networkmanager.enable = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = ["heiytor"];
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  fileSystems."/mnt/extern-1" = {
    device = "/dev/disk/by-uuid/39f3f8e2-b801-4720-838e-877031207e06";
    fsType = "ext4";
    options = [ "rw" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
  ];
}
