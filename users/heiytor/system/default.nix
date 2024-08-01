{ config, pkgs, inputs, ... }:

{
  users.users.heiytor = {
    isNormalUser = true;
    description = "Heitor Danilo";
    extraGroups = [
      "audio"
      "networkmanager"
      "wheel"
      "docker"
      "storage"
    ];
    shell = pkgs.zsh;
    openssh = { 
      authorizedKeys = {
        keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCw1KIXyrzdTjoRHhOpKQQQ8xanlfNqYxpuI5CDUBU315nrj8c7yrFRKs3pRpbknKp2aP2q5fV0eM2e+eDneT1VRXanwwZD4bdS1EFsNPI5V7N+sSqzF3KVhduz/81ikGx21PO5Yx0rpgzAJf1YAXAdgSEuOGpZSi6ONC4CqfbUWKTeIpzg4Cj8s8mAnWtSfJouIhDp9JqI8FrDyx0r2M07bSHe9QoF9GVdPALzB/HMfcLR7l1uydxxG3OtASJHU6s3ZPejJIqpKkg2/2EfCY8OHoG/2Ko8OCZ66TwWHJKT1jymcXl49yVwVGNIeFAyOCPhvBbGGbSfcFGzG+yNkYoHh+njBZt06BdLl1STaD67YgX3DRwI/d6cllQU1FNfp1L/1oktlEXxtnFjrU3345woYs3BIkY4LtoPen4R7rz9z033sCErzRib4SbaZ0cGxUdSqSSvXZJqQIMO8k1rpZiMIZUvChz6KmARIzaDJWEquBgLh4P2W7wGdTzBY7mtJRLkWmNVAco18fTja5/oWqQtEK7xZ0Q7RxTwwCdo8JvKmcHKXuSjIS9y4svGDzUAp4DBJ1YrN+34YULBJtkA0Z2WXSn9BC+4oxCZhMl74H7UL23OVwn3UfaCgXWTYzmR/nHLfidXuU/IDhB4/uJ8TH0RxvFgY05oJRCGkaO25T6Rpw== heitor.barros@speedio.com.br"
        ];
      };
    };
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
