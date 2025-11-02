{config,pkgs,...}:
{
  # Duvar kağıdı otomatik değiştirici
  systemd.user.services.wallchange = {
    Unit = {
      Description = "Change wallpaper periodically";
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c '
          WALLPAPERS="$HOME/pictures/"
          RANDOM_WALL=$(find "$WALLPAPERS" -type f | shuf -n 1)
          ${pkgs.swww}/bin/swww img "$RANDOM_WALL" --transition-type fade --transition-duration 2
        '
      '';
    };
  };

  systemd.user.timers.wallchange = {
    Unit.Description = "Wallpaper change timer";
    Timer = {
      OnBootSec = "5s";
      OnUnitActiveSec = "30s";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}

