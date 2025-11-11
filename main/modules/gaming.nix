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
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };
}
