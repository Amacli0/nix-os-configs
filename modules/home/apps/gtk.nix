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

    # Frutiger Aero/Glossy hissiyatı veren aydınlık GTK teması
    theme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };

    # Parlak ve renkli ikon seti (Yaru / Breeze veya Papirus-Light)
    iconTheme = {
      name = "Yaru";
      package = pkgs.yaru-theme;
    };

    # Yumuşak ve modern imleç
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

  # İmlecin tüm sistemde varsayılan olması için
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
