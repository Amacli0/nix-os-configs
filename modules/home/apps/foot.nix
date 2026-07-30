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
        font = lib.mkForce "Terminus:size=16";
        pad = "8x8";
      };
      tweak = {
        font-monospace-warn = "no"; # Monospace uyarısını tamamen sessize al
      };
    };
  };
}
