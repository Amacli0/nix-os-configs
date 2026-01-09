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
      settings = {
        font = {
          name = lib.mkForce "JetBrainsMono Nerd Font";
          size = 12;
        };
      };
    };
  };
}
