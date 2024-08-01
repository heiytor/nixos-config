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
    # theme = "Jellybeans";
    extraConfig = ''
      background            #ffffff
      foreground            #16181a
      cursor                #16181a
      cursor_text_color     #ffffff
      selection_background  #acacac
      color0                #ffffff
      color8                #ffffff
      color1                #d11500
      color9                #d11500
      color2                #008b0c
      color10               #008b0c
      color3                #997b00
      color11               #997b00
      color4                #0057d1
      color12               #0057d1
      color5                #a018ff
      color13               #a018ff
      color6                #008c99
      color14               #008c99
      color7                #16181a
      color15               #16181a
      selection_foreground  #16181a
    '';
  };
}
