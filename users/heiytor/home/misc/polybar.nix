{ config, pkgs, ... }:

{
  services.polybar = {
    package = pkgs.polybarFull;
    enable = true;
    script = ''
      polybar-msg cmd quit
      polybar example 2>&1 | tee -a /tmp/polybar.log & disown
    '';
    config = {
      "colors" = {
        background = "#161616";
        foreground = "#C6C6C6";
        primary = "#AF87D7";
        alert = "#AF5F87";
        disabled = "#707880";
      };
      "bar/example" = {
        font-0 = "JetBrainsMono:size=10;2";
        font-1 = "Font Awesome 6 Free Solid:size=9;2";
        width = "100%";
        height = "18pt";
        radius = 0;
        border-size = "0pt";
        border-color = "#00000000";
        background = "\${colors.background}";
        foreground = "\${colors.foreground}";
        line-size = "3pt";
        padding-left = 0;
        padding-right = 1;
        module-margin = 1;
        separator = "|";
        separator-foreground = "\${colors.disabled}";
        modules-left = "tags windows";
        modules-right = "audio cpu mem date systray";
        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
        enable-ipc = true;
      };
      "module/tags" = {
        type = "internal/xworkspaces";
        label-active = "%name%";
        label-active-background = "\${colors.background}";
        label-active-underline= "\${colors.primary}";
        label-active-padding = 1;
        label-occupied = "%name%";
        label-occupied-padding = 1;
        label-occupied-background = "\${colors.background}";
        label-urgent = "%name%";
        label-urgent-background = "\${colors.alert}";
        label-urgent-padding = 1;
        label-empty = "%name%";
        label-empty-foreground = "\${colors.disabled}";
        label-empty-padding = 1;
      };
      "module/windows" = {
        type = "internal/xwindow";
        label = "%title:0:60:...%";
      };
      "module/audio" = {
        type = "internal/pulseaudio";
        format-volume-prefix = "VOL ";
        format-volume-prefix-foreground = "\${colors.primary}";
        format-volume = "<label-volume>";
        label-volume = "%percentage%%";
        label-muted = "muted";
        label-muted-foreground = "\${colors.disabled}";
      };
      "module/cpu" = {
        type = "internal/cpu";
        interval = 2;
        format-prefix = "CPU ";
        format-prefix-foreground = "\${colors.primary}";
        label = "%percentage:2%%";
      };
      "module/mem" = {
        type = "internal/memory";
        interval = 2;
        format-prefix = "RAM ";
        format-prefix-foreground = "\${colors.primary}";
        label = "%percentage_used:2%%";
      };
      "module/date" = {
        type = "internal/date";
        interval = 1;
        date = "%a %Y-%m-%d %H:%M"; # Fri 2024-03-29 09:23
        label = "%date%";
        label-foreground = "\${colors.foreground}";
      };
      "module/systray" = {
        type = "internal/tray";
        format-margin = "0pt";
        tray-spacing = "8pt";
      };
      "settings" = {
        screenchange-reload = true;
        pseudo-transparency = true;
      };
    };
  };
}
