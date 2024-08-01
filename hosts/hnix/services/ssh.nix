{ config, pkgs, inputs, ... }:

{
  services.openssh = {
    enable = true;
  };

  programs.ssh = {
    extraConfig = ''
      Host code-challenge.milenio.capital
        PreferredAuthentications publickey
        IdentityFile ~/.ssh/87102469e28aab15b1d1ef25d17770c8199aad69
    '';
  };
}

