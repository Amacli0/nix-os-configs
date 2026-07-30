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
  gtk = {
    enable = true;
    theme = {
      name = "Chicago95";
      package = pkgs.chicago95;
    };
    iconTheme = {
      name = "Chicago95";
      package = pkgs.chicago95;
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
