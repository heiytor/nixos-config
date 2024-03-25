{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    tree
  ];

  programs.eza = {
    enable = true;
    icons = true;
    git = true;
    enableAliases = true;
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    shellAliases = {
      "rebuild" = "sudo nixos-rebuild switch --flake /home/heiytor/nixos#hnix";

      "g" = "git";
      "v" = "nvim";
      "c" = "clear";
      "tb" = "nc termbin.com 9999";
    };
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "sorin";
    };
  };
}
