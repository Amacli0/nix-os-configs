#######################################
#             STYLE                  #
#######################################
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/windows-95.yaml";
  stylix.polarity = "dark";

  stylix.targets.gtk.enable = false;
  stylix.targets.gnome.enable = false;
}
