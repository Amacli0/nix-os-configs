#######################################
#           GTK & CURSOR              #
#######################################
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  stylix.targets.gtk.enable = false;
  gtk = {
    enable = true;
    theme = {
      name = lib.mkForce "Chicago95";
      package = lib.mkForce pkgs.chicago95;
    };
    iconTheme = {
      name = lib.mkForce "Chicago95";
      package = lib.mkForce pkgs.chicago95;
    };
  };

  home.pointerCursor = {
    enable = true;
    name = "Chicago95";
    package = pkgs.chicago95;
    size = 24;
    gtk.enable = true;
  };
}
