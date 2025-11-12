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
    desktopManager.gnome.enable = true;
  };
  qt = {
    enable = true;
    platformTheme = "gnome";
  };

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };
  };
}
