{ config, pkgs, inputs, ... }:

{
  users.users.heiytor = {
    isNormalUser = true;
    description = "Heitor Danilo";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "storage"
    ];
    shell = pkgs.zsh;
  };

  # Avoid ignoreShellProgramCheck error. Must need to add `zsh.dotDir` later.
  programs.zsh = {
    enable = true;
  };

  time = {
    timeZone = "America/Sao_Paulo";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };
}
