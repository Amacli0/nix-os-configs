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
    libinput.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };
  };

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };
  };
}
