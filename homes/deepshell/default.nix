{
  config,
  pkgs,
  lib,
  inputs,
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
    ../../modules/home/general/home-packages.nix
    ../../modules/home/apps/obs.nix
    ../../modules/home/apps/firefox.nix
    ../../modules/home/apps/git.nix
    ../../modules/home/apps/kitty.nix
    ../../modules/home/apps/waybar.nix
    ../../modules/home/apps/zsh.nix
    ../../modules/home/apps/tmux.nix
    ../../modules/home/apps/foot.nix
    ../../modules/home/apps/neovim.nix
  ];

  # Konfigürasyon dosyası bağlantıları
  home.file.".config/niri/config.kdl".source = ./files/niri/config.kdl;
  home.file.".config/SuperCollider/startup.scd".source = ./files/supercollider/startup.scd;

  ########################
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
