{ config, pkgs, ... }:

{
  systemd.user.services.wallchange = {
    Unit = {
      Description = "Change wallpaper periodically";
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = ''
        WALLPAPERS="$HOME/pictures"
        RANDOM_WALL=$(find "$WALLPAPERS" -type f | shuf -n 1)
        ${pkgs.swww}/bin/swww img "$RANDOM_WALL" \
          --transition-type fade \
          --transition-duration 2
      '';
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.timers.wallchange = {
    Unit = {
      Description = "Wallpaper change timer";
    };

    Timer = {
      OnBootSec = "5s";
      OnUnitActiveSec = "30s"; # 30 saniye yerine 30 dakika önerilir
      AccuracySec = "1s";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}

