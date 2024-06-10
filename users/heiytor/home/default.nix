{ config, pkgs, inputs, ... }:

{
  # Self download
  programs.home-manager.enable = true;

  home = {
    username = "heiytor";
    homeDirectory = "/home/heiytor";
    stateVersion = "24.05";
  };

  imports = [
    (import ./editor/nvim.nix { inherit config pkgs; })
    (import ./misc/direnv.nix {})
    (import ./misc/fonts.nix { inherit config pkgs; })
    (import ./misc/git.nix { inherit config pkgs; })
    (import ./misc/picom.nix { inherit config pkgs; })
    (import ./misc/polybar.nix { inherit config pkgs; })
    (import ./misc/ssh.nix { inherit config pkgs;})
    (import ./shell/zsh.nix { inherit config pkgs; })
    (import ./terminal/alacritty.nix { inherit config pkgs; })
    (import ./terminal/kitty.nix { inherit pkgs; })
  ];

  nixpkgs = {
    overlays = [
      inputs.neovim-nightly-overlay.overlay
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home.sessionVariables = {
    TERMINAL = "alacritty";
  };

  home.packages = with pkgs; [
    # Packages that I don't need to handle manually
    firefox
    discord
    feh         # Image viewer
    flameshot   # Screenshot software
    gh          # Github CLI
    delta       # Git syntax-highlighting pager
    rofi        # Dmenu replacement
    pavucontrol # Volume control
    xclip       # Clipboard library
    httpie      # HTTP client
    insomnia    # Rest API client
    alsa-utils
    yad         # Dialog helper
    unzip
    unrar
    nix-prefetch
    vlc
    
    obs-studio
  ];
}
