{
  config,
  pkgs,
  lib,
  ...
}: {
  home.username = "deepshell";
  home.homeDirectory = "/home/deepshell";
  home.stateVersion = "25.05";

  imports = [
    ./modules/hyprland.nix
    ./modules/nvim.nix
  ];

  home.packages = with pkgs; [
    kitty
    fastfetch

    bitwarden-desktop

    hyprland

    whatsapp-electron
    waybar
    tree
    pavucontrol
    blueman
    rofi
    yazi
    vscodium
    xclip
    wl-clipboard
    lua-language-server
    nixd
    swww
    waypaper
    btop

    hyprpolkitagent
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
      font = {
        name = lib.mkForce "Monocraft";
        size = 12;
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

    waybar = {
      enable = true;
    };
  };

  home.file = {};

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
