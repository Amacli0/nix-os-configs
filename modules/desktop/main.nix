#######################################
#              DESKTOP                #
#######################################
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  programs.niri.enable = true;

  services = {
    displayManager.ly = {
      enable = true;
      settings = {
        animation = "matrix";
        clear_password = true;
        bigclock = "en";
        clock = "%H:%M:%S";
        date = "%a %d %b";
        auth_fails = 3;
        load = true;
        save = true;
        battery_id = "BAT0";
        numlock = false;
      };
    };
  };
}
