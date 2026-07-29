{
  config,
  pkgs,
  lib,
  ...
}: {
  #######################################
  #            BASIC SETTİNGS           #
  #######################################
  home.username = "softshell";
  home.homeDirectory = "/home/softshell";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    firefox
    btop
    kitty
  ];
}
