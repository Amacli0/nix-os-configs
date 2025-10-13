{
  config,
  pkgs,
  lib,
  ...
}: let
  mod = "SUPER";
in {
  home.username = "deepshell";
  home.homeDirectory = "/home/deepshell";
  home.stateVersion = "25.05";

  imports = [
    ./modules/hyprland.nix
  ];

  home.packages = with pkgs; [
    vim
    neovim
    kitty
    git
    bitwarden-desktop
    fastfetch
    hyprland
    alejandra
  ];

  programs = {
    git = {
      enable = true;
      userName = "Mehmet Şükrü Bilgiç";
      userEmail = "deepshell@proton.me";
    };

    firefox.enable = true;

    kitty = {
      enable = true;
      settings = {
        confirm_os_window_close = -1;
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;

      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch --flake /etc/nixos#Nixtilus";
      };

      history.size = 10000;

      oh-my-zsh = {
        enable = true;
        plugins = ["git"];
        theme = "kphoen";
      };
    };
  };

  home.file = {};

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
