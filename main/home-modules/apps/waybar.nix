#######################################
#               WAYBAR                #
#######################################
{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;

    settings = {
      main = {
        position = "top";

        # SOL
        modules-left = [
          "clock#date"
          "hyprland/window"
        ];

        # ORTA
        modules-center = [
          "hyprland/workspaces"
        ];

        # SAĞ
        modules-right = [
          "network"
          "cpu"
          "memory"
          "pulseaudio"
          "battery"
          "clock#time"
        ];

        ############################

        # Modül ayarları
        "clock#date" = {
          format = "{:%A, %d %B}";
          tooltip = false;
        };

        "clock#time" = {
          format = "{:%H:%M}";
          tooltip = false;
        };

        network = {
          format-wifi = "  {essid}";
          format-ethernet = " {ipaddr}";
          format-disconnected = "Connection Lost";
          tooltip = false;
        };

        cpu = {
          format = " {usage}%";
        };

        memory = {
          format = " {used} / {total}";
        };

        pulseaudio = {
          format = " {volume}%";
          format-muted = " muted";
        };
      };
    };
  };
}
