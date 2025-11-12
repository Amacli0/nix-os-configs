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

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };
    xserver = {
      desktopManager.gnome.enable = true;
      displayManager.sddm.enable = true;
    };
  };
  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };
  };
}
