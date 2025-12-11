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
    profiles = {
      default = {};
      work = {};
    };
  };
}
