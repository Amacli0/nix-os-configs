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
      settings = {
        animate = true;
        animation = "rain";

        bigclock = true;
        clock = "%H:%M:%S";
        date = "%a %d %b"; # Örn: Çar 12 Kas

        message = "Bu ly harika değil mi hehehe...                    zamanımı boşa harcıyorum.";

        allow_root = false;

        # Diğer Ayarlar
        hide_f1_commands = true;
        vt_switching = true;
      };
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
