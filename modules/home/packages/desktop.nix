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
    foot
    fuzzel
    waybar
    grim
    slurp
    awww
    waypaper
    pavucontrol
    blueman
    brightnessctl
    noctalia-shell
    xdg-desktop-portal-gtk
    xwayland-satellite
  ];
}
