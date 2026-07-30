{
  config,
  pkgs,
  ...
}: {
  # Waybar servisini aktif et

  programs.waybar = {
    enable = true;
  };
  # Kendi hazırladığın config ve style.css dosyalarını buradan bağlıyoruz:
  home.file.".config/waybar/config".source = ../../../homes/deepshell/files/waybar/config;
  home.file.".config/waybar/style.css".source = ../../../homes/deepshell/files/waybar/style.css;
}
