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
    libinput.enable = true;

    displayManager.ly = {
      enable = true;
    };

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
