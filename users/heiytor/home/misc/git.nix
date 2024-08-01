{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "nvim";
        pager = "delta";
        autocrlf = "input";
      };
      user = {
        name = "Heitor Danilo";
        email = "heitor.danilo@icloud.com";
      };
      interactive = {
        diffFilter = "delta --color-only";
      };
      delta = {
        navigate = true;
        light = false;
        side-by-side = true;
      };
      commit = {
        gpgSign = false;
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
    };
    includes = [
      {
        condition = "gitdir:~/projects/oss/";
        contents = {
          user = {
            email = "heitor.danilo@ossystems.com.br";
          };
        };
      }
      {
        condition = "gitdir:~/projects/speedio/";
        contents = {
          user = {
            email = "heitor.barros@speedio.com.br";
          };
        };
      }
    ];
  };

  # programs.gh = {
  #   enable = true;
  #   settings = {
  #     git_protocol = "ssh";
  #     editor = "nivm";
  #   };
  # };
}
