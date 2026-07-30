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

  home.file.".config/SuperCollider/startup.scd".source = ./files/supercollider/startup.scd;
  home.file.".config/niri/config.kdl".source = ./files/niri/config.kdl;
  ########################
  home.pointerCursor.enable = true;
}
