{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "23.11";

  networking.hostName = "hnix";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
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

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  programs.zsh = {
    enable = true;
  };

  users.users.heiytor = {
    isNormalUser = true;
    description = "Heitor Danilo";
    extraGroups = [ "networkmanager" "wheel" "docker" "storage" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };


  nixpkgs.config.allowUnfree = true;

  # nixpkgs.overlays = [
  #   (import (builtins.fetchTarball {
  #     url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
  #   }))
  # ];

  environment.systemPackages = with pkgs; [
    git
    vim
    zsh
    xclip
  ];

  # X11 and AwesomeWM
  services.xserver = {
    enable = true;
    autorun = true;
    layout = "us";
    xkbVariant = "";
    displayManager = {
      lightdm = {
        enable = true;
      };
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

  # SSH
  services.openssh = {
    enable = true;
  };

  # Audio and pipewire
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse = {
      enable = true;
    };
  };
  # Recommended to use with pipewire
  security.rtkit = {
    enable = true;
  };

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

  virtualisation.docker = {
    enable = true;
    daemon = {
      settings = {
        data-root = "/mount/extern-1/lib/docker";
      };
    };
  };

  # TODO: put it in the home.nix
  # programs.zsh = {
  #   enable = true;
  #   shellAliases = {
  #     "g" = "git";
  #     "v" = "vim";
  #     "c" = "clear";

  #     "rebuild" = "sudo nixos-rebuild switch";
  #   };
  #   enableCompletion = true;
  #   autosuggestions = {
  #     enable = true;
  #   };
  #   syntaxHighlighting = {
  #     enable = true;
  #   };
  #   ohMyZsh = {
  #     enable = true;
  #     plugins = [ "git" "sudo" ];
  #     theme = "sorin";
  #   };
  # };
}
