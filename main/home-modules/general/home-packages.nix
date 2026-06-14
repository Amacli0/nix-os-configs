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
    nfs-utils
    syncthing
    pinta

    brave

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
    awww
    waypaper
    pavucontrol
    blueman
    brightnessctl
    noctalia-shell
    vial
    via

    # --- SDR & Hardware ---
    rtl-sdr
    sdrpp

    # --- Apps & Social ---
    whatsapp-electron
    spotify
    libreoffice
    freetube

    # --- Gaming ---
    vitetris
    godot
    pokemmo-installer
    wine
    retroarch-free
    antimicrox
    lutris
    ruffle
    osu-lazer

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
    nicotine-plus
    picard
    supersonic-wayland
    strawberry
    zrythm
    supercollider
    helvum
    (haskellPackages.ghcWithPackages (hp:
      with hp; [
        tidal
      ]))

    # --- Ctf and Stuff ---
    openvpn
    nmap
    gobuster
    netcat
    exploitdb
  ];
  nixpkgs.config.allowUnfree = true;
}
