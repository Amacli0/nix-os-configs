#######################################
#            FİREFOX                  #
#######################################
{
  config,
  pkgs,
  lib,
  ...
}: {
  stylix.targets.firefox.profileNames = ["default"];

  programs = {
    firefox.enable = true;
    firefox.configPath = "${config.home.homeDirectory}/.mozilla/firefox";
  };
}
