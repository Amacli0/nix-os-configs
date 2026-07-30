########################
#         FOOT         #
########################
{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = lib.mkForce "Fixedsys Excelsior:size=12";
        pad = "8x8";
      };
      colors = {
        background = "000000";
        foreground = "c0c0c0";
      };
    };
  };
}
