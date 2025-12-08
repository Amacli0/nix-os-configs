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
    kitty
    fastfetch

    bitwarden-desktop

    whatsapp-electron

    waybar

    pavucontrol
    blueman
    rofi
    yazi
    vscodium
    xclip
    wl-clipboard

    swww

    btop
    polkit_gnome
    tor-browser

    cheese
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

    go
    delve

    python3
  ];
  nixpkgs.config.allowUnfree = true;
}
