{pkgs, ...}: {
  home.packages = with pkgs; [
    # Tarayıcılar ve Uygulamalar
    brave
    pinta
    joplin-desktop
    qbittorrent
    whatsapp-electron
    libreoffice

    # Wayland & Shell
    fuzzel
    grim
    slurp
    chicago95
    awww
    waypaper
    pavucontrol
    blueman
    brightnessctl
    xdg-desktop-portal-gtk
    xwayland-satellite
  ];
}
