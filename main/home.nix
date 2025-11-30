{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  #######################################
  #            BASIC SETTİNGS           #
  #######################################
  home.username = "deepshell";
  home.homeDirectory = "/home/deepshell";
  home.stateVersion = "25.05";
  #######################################
  #            IMPORTS                  #
  #######################################
  imports = [
    ./home-modules/general/hyprland.nix
    ./home-modules/general/home-packages.nix
    ###
    ./home-modules/apps/obs.nix
    ./home-modules/apps/firefox.nix
    ./home-modules/apps/git.nix
    ./home-modules/apps/kitty.nix
    ./home-modules/apps/waybar.nix
    ./home-modules/apps/zsh.nix
    ./home-modules/apps/nixvim.nix
    ./home-modules/apps/tmux.nix
  ];
}
