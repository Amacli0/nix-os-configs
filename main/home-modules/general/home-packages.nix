#######################################
#            PAKETLER                 #
#######################################
{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    fastfetch
    yazi
    bat
    btop
    tree
    unzip
    zip
    wl-clipboard
    ffmpegthumbnailer
    poppler

    # --- DevOps & Cloud ---
    opentofu
    terraform
    awscli2
    docker
    docker-compose
    distrobox
    ansible
    kubectl
    opentofu

    # --- Development & Infrastructure ---
    platformio
    avrdude
    go
    delve
    python3
    vscodium
    esptool
    zellij

    # --- Wayland & Desktop ---
    foot
    fuzzel
    waybar
    grim
    slurp
    swww
    waypaper
    pavucontrol
    blueman
    brightnessctl
    w3m-full

    # --- SDR & Hardware ---
    rtl-sdr
    sdrpp

    # --- Apps & Social ---
    bitwarden-desktop
    whatsapp-electron
    spotify
    libreoffice

    # --- Gaming ---
    vitetris
    godot
    pokemmo-installer
    wine
    retroarch-full
    # --- Media & Documents ---
    mpv
    sioyek

    # --- System Services & Wayland Support ---
    fontconfig
    xdg-utils
    xdg-desktop-portal-gtk
    xwayland-satellite

    # --- Music and Utau ---
    openutau
    ardour
  ];
  nixpkgs.config.allowUnfree = true;
}
