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
  home.username = lib.mkDefault "deepshell";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
  home.stateVersion = "25.05";
  #######################################
  #            IMPORTS                  #
  #######################################
  imports = [
    inputs.noctalia.homeModules.default
    ../../modules/home/packages
    ../../modules/home/apps
  ];

  programs.noctalia = {
    enable = true;
  };

  # Konfigürasyon dosyası bağlantıları
  home.file.".config/niri/config.kdl".source = ./files/niri/config.kdl;
  home.file.".config/SuperCollider/startup.scd".source = ./files/supercollider/startup.scd;

  ########################
  home.pointerCursor.enable = true;

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
