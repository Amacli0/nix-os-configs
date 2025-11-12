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
        bigclock = false;
        clock = "%H:%M:%S";
        date = "%a %d %b";
        message = "IZTECH Computer Engineering Loading...";
        vt_switching = true;
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
