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
    xserver = {
      displayManager.ly = {
        enable = true;
        settings = {
          animate = true;
          animation = "rain";

          bigclock = true;
          clock = "%H:%M:%S";
          date = "%a %d %b"; # Örn: Çar 12 Kas

          message = "Bu ly harika değil mi hehehe...                    zamanimi boşa harciyorum.";

          allow_root = false;

          # Diğer Ayarlar
          hide_f1_commands = true;
          vt_switching = true;
        };
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
