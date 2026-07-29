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
    ../../modules/home/packages
    ../../modules/home/apps
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
