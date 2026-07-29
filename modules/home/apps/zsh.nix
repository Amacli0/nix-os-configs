#######################################
#                ZSH                  #
#######################################
{
  config,
  pkgs,
  lib,
  ...
}: {
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;

      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch --flake .#Nixtilus";
      };

      history.size = 10000;

      oh-my-zsh = {
        enable = true;
        plugins = ["git"];
        theme = "kphoen";
      };
    };
  };
}
