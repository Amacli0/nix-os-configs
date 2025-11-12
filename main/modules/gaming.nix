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
    #STEAM
    steam = {
      enable = true;
    };
    gamemode.enable = true;
  };
}
