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

  # 2. Tell Home Manager to recursively map your files into ~/.config/noctalia
  home.file.".config/noctalia" = {
    source = ./files/noctalia;
    recursive = true; # <-- This allows Home Manager to merge files instead of replacing the folder with a rigid symlink!
  };

  # Konfigürasyon dosyası bağlantıları

  home.file.".config/SuperCollider/startup.scd".source = ./files/supercollider/startup.scd;
  home.file.".config/noctalia/settings.json".source = ./files/noctalia/settings.json;
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

  home-manager.backupFileExtension = "backup";
}
