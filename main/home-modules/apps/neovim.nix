#######################################
#               NEOVİM                #
#######################################
{
  config,
  pkgs,
  lib,
  ...
}: {
  programs = {
    neovim.enable = false;
  };
}
