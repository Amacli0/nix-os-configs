#######################################
#              GAMING                 #
#######################################
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  programs = {
    steam = {
      enable = true;
    };
    gamemode.enable = true;
  };
}
