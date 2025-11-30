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
}
