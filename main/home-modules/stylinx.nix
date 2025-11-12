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

  # Ayrıca bu platformlar için Kvantum motorunu tercih etmeniz en iyisidir.
  # Stylix, Kvantum'u otomatik olarak doğru renklere ayarlar.
  home.packages = with pkgs; [
    # Gerekli Kvantum paketlerini yüklüyoruz
    qt5.qtbase.platformThemes.kvantum
    qt6.qtbase.platformThemes.kvantum
  ];

  # home-manager'ın bu platform temalarını kullanması gerektiğini beyan ediyoruz
  # Bu, QT_PLATFORM_THEME environment variable'ını ayarlar.
  qt.enable = true;
  qt.platformTheme = "qt5ct"; # qt5ct, Kvantum'u yöneten en yaygın Qt Config Tool'dur.
}
