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

    bitwarden-desktop

    whatsapp-electron

    waybar

    pavucontrol
    blueman
    yazi
    vscodium
    wl-clipboard

    ffmpegthumbnailer
    poppler
    fontconfig

    swww

    btop
    polkit_gnome
    tor-browser

    waypaper

    tree
    prismlauncher

    nextcloud-client

    bat

    vitetris

    spotify

    terraform

    awscli2

    superTuxKart

    openttd

    lutris
    heroic
    wine

    go
    delve

    python3

    grim
    slurp

    unzip
    zip

    libreoffice

    sioyek

    brightnessctl

    xdg-utils
    xdg-desktop-portal-gtk

    pokemmo-installer

    fuzzel
    xwayland-satellite
    foot

    distrobox

    vlc

    godot

    rtl-sdr
    sdrpp

    platformio
    avrdude
    esptool
  ];
  nixpkgs.config.allowUnfree = true;
}
