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
          "niri/window"
          "wlr/taskbar"
        ];

        # ORTA
        modules-center = [
          "niri/workspaces"
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
        "niri/workspaces" = {
          format = "{icon}";
          # Niri'de workspace'ler genelde dinamiktir
        };

        # Taskbar (Görev Çubuğu) Ayarı
        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 18;
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
        };

        "niri/window" = {
          format = " {title}";
          separate-outputs = true;
        };

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
