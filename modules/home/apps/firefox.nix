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
    firefox.configPath = "home/deepshell/.mozilla/firefox";
  };
}
