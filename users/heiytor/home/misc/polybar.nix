{ config, pkgs, ... }:

{
  services.polybar = let
    amixer = "${pkgs.alsa-utils}/bin/amixer";
    grep = "${pkgs.gnugrep}/bin/grep";
  in {
    package = pkgs.polybarFull;
    enable = true;
    script = ''
      polybar-msg cmd quit
      polybar example 2>&1 | tee -a /tmp/polybar.log & disown
    '';
    config = {
      "colors" = {
        # background = "#161616"; 
        # foreground = "#C6C6C6";
        # primary = "#AF87D7";
        # alert = "#AF5F87";
        # disabled = "#707880";
        # urgent = "#F27360";

        background = "#FFFFFF";
        foreground = "#16181A";
        primary = "#008B0C";
        alert = "#D100Bf";
        disabled = "#7B8496";
        urgent = "#D11500";
      };
      "bar/example" = {
        bottom = true;

        font-0 = "JetBrainsMono:size=10;2";
        # Nerd fonts
        font-1 = "FontAwesome6Free:style=Solid:size=9;2";
        font-2 = "FontAwesome6Free:style=Regular:size=9;2";
        font-3 = "FontAwesome6Brands:style=Regular:size=9;2";

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
        separator = "";
        separator-foreground = "\${colors.disabled}";
        modules-left = "tags";
        modules-center = "date";
        modules-right = "systray  audio microphone";
        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
        enable-ipc = true;
      };
      "module/windows" = {
        type = "internal/xwindow";
        label = "%title:0:60:...%";
      };
      "module/microphone" = {
        type = "custom/script";
        tail = true;
        exec = ''
          if ${amixer} get Capture | ${grep} -q '\\[on\\]'; then echo ''; else echo ''; fi
        '';
        click-left = ''
          ${amixer} set Capture toggle
        '';
      };
      "module/audio" = {
        type = "internal/pulseaudio";
        use-ui-max = false;
        interval = 5;

        format-volume = "<ramp-volume>";
        ramp-volume-0 = "";
        ramp-volume-1 = "";
        ramp-volume-2 = "";

        format-muted = "<label-muted>";
        label-muted = "muted";
        label-muted-foreground = "\${colors.urgent}";
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
        tray-size = "60%";
        tray-spacing = "12pt";
        format-margin = "0pt";
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
      "settings" = {
        screenchange-reload = true;
        pseudo-transparency = true;
      };
    };
  };
}
