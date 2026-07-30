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
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/oceanicnext.yaml";
  stylix.polarity = "light";

  stylix.targets.gtk.enable = false;
  stylix.targets.gnome.enable = false;
}
