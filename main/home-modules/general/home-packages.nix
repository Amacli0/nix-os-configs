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
    prismlauncher
    vitetris
    superTuxKart
    godot
    openttd
    pokemmo-installer
    lutris
    heroic
    wine
    luanti

    # --- Media & Documents ---
    mpv
    sioyek

    # --- System Services & Wayland Support ---
    fontconfig
    xdg-utils
    xdg-desktop-portal-gtk
    xwayland-satellite
  ];
  nixpkgs.config.allowUnfree = true;
}
