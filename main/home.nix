{
  config,
  pkgs,
  lib,
  ...
}: {
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
    ./modules/hyprland.nix
  ];
  #######################################
  #            PAKETLER                 #
  #######################################
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
    polkit_gnome

    cheese
    ob
  ];
  #######################################
  #            PROGRAMLAR               #
  #######################################
  programs = {
    #######################################
    #               OBS                   #
    #######################################
    obs-studio = {
      enable = true;
    };
    #######################################
    #                GİT                  #
    #######################################
    git = {
      enable = true;
      settings = {
        user.name = "Mehmet Şükrü Bilgiç";
        user.email = "deepshell@proton.me";
      };
    };
    #######################################
    #            FİREFOX                  #
    #######################################
    firefox.enable = true;
    #######################################
    #            KİTTY                    #
    #######################################
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
    #######################################
    #            ZSH                      #
    #######################################
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
    #######################################
    #            BARS                     #
    #######################################
    waybar = {
      enable = true;
    };
  };
  #######################################
  #            EVRENSEL                 #
  #######################################
  home.file = {};

  home.sessionVariables = {
    EDITOR = "nvim";
  };
  #######################################
  #            POLKİT               #
  #######################################
  systemd.user.services.polkit-gnome-agent = {
    Unit = {
      Description = "Polkit GNOME Authentication Agent";
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
