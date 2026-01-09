########################
#         FOOT         #
########################
{
  config,
  pkgs,
  lib,
  ...
}: {
  programs = {
    foot = {
      enable = true;
    };
  };
}
