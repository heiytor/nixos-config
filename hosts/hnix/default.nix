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
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  # Mount external devices
  fileSystems."/mount/extern-1" =
    { device = "/dev/disk/by-uuid/262aba5c-d6f1-46bd-8602-60d36d1c1dd0";
      fsType = "btrfs";
    };

  nixpkgs.config.allowUnfree = true;

  # Disable sudo password prompt
  security.sudo.extraRules = [
    {
      users = [ "heiytor" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
