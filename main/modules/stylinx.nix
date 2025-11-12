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
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

  stylix.targets = {
    # Qt5 uygulamalarını temalaştırır.
    qt5.enable = true;

    # Qt6 uygulamalarını temalaştırır.
    qt6.enable = true;
  };

  # home-manager'ın bu platform temalarını kullanması gerektiğini beyan ediyoruz
  # Bu, QT_PLATFORM_THEME environment variable'ını ayarlar.
  qt.enable = true;
  qt.platformTheme = "qt5ct"; # qt5ct, Kvantum'u yöneten en yaygın Qt Config Tool'dur.
}
