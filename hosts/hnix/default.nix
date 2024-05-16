{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix

      ./security/sudo.nix
      ./services/docker.nix
      ./services/pipewire.nix
      ./services/xserver.nix
      ./services/ssh.nix
      ./services/udev.nix
      ./services/zerotier.nix
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

  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/extern-1" = {
    device = "/dev/disk/by-uuid/AE1A53381A52FCB1";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000"];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    xclip
    gnumake
  ];
}
