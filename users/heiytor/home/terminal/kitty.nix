{ pkgs }:

{
  programs.kitty = {
    package = pkgs.kitty;
    enable = true;
    font = {
      name = "JetBrainsMono";
      size = 12;
      package = pkgs.jetbrains-mono;
    };
    theme = "Jellybeans";
  };
}
