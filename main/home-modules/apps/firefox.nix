#######################################
#            FİREFOX                  #
#######################################
{
  config,
  pkgs,
  lib,
  ...
}: {
  programs = {
    firefox.enable = true;
  };
  config.stylix.targets.firefox.profileNames = ["default"];
}
