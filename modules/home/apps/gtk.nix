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
  stylix.targets.qt.enable = false;

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "oxygen";
      package = pkgs.kdePackages.oxygen;
    };
  };

  gtk = {
    enable = true;
    gtk4.theme = config.gtk.theme;
    # Frutiger Aero/Glossy hissiyatı veren aydınlık GTK teması
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "oxygen";
      package = pkgs.kdePackages.oxygen-icons;
    };

    # Yumuşak ve modern imleç
    cursorTheme = {
      name = "Oxygen-White";
      package = pkgs.kdePackages.oxygen;
      size = 24;
    };
  };

  # İmlecin tüm sistemde varsayılan olması için
  home.pointerCursor = {
    name = "Oxygen-White";
    package = pkgs.kdePackages.oxygen;

    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
