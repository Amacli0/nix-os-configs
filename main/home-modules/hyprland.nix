{
  config,
  pkgs,
  lib,
  ...
}: {
  #######################################
  #            HYPRLAND AYARLARI        #
  #######################################
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.hyprland;
    #######################################
    #            SETTINGS                 #
    #######################################
    settings = {
      #######################################
      #            ATAMALAR                 #
      #######################################
      "$mod" = "SUPER";
      "$alt" = "Alt";
      "$space" = "SPACE";
      "$control" = "CTRL";
      "$shift" = "SHIFT";
      "$terminal" = "kitty";
      "$menu" = "rofi";
      #######################################
      #            BAŞLANGIÇ                #
      #######################################
      exec-once = [
        "${pkgs.waybar}/bin/waybar"
        "swww-daemon"
        "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &"
      ];
      #######################################
      #            MONITOR                  #
      #######################################

      "monitor" = "eDP-1, 1920x1080@144, 0x0, 1";

      #######################################
      #            GENEL AYARLAR            #
      #######################################
      general = {
        "layout" = "dwindle";
        "gaps_in" = 5;
        "gaps_out" = 10;
        "border_size" = 2;
      };
      #######################################
      #            KLAVYE                  #
      #######################################
      input = {
        "kb_layout" = "tr";
        "kb_variant" = "";
        "kb_options" = "";
        "follow_mouse" = 1;
        "sensitivity" = 0.2;
        "touchpad" = {
          "natural_scroll" = true;
        };
      };
      #######################################
      #            KISAYOLLAR               #
      #######################################
      "bind" = [
        "$mod, T, exec, $terminal"
        "$mod, Q, killactive"
        "$mod SHIFT, M, exit"
        "$mod, F, fullscreen"
        "$mod, V, togglefloating"
        "$mod, M, exit"
        "$alt, $space,exec, $menu -show drun"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        "$mod $shift, left, movewindow, l"
        "$mod $shift, right, movewindow, r"
        "$mod $shift, up, movewindow, u"
        "$mod $shift, down, movewindow, d"

        "$mod, 1 , workspace, 1"
        "$mod, 2 , workspace, 2"
        "$mod, 3 , workspace, 3"
        "$mod, 4 , workspace, 4"
        "$mod, 5 , workspace, 5"
        "$mod, 6 , workspace, 6"
        "$mod, 7 , workspace, 7"
        "$mod, 8 , workspace, 8"
        "$mod, 9 , workspace, 9"
        "$mod, 0 , workspace, 10"

        "$mod $shift, 1 ,  movetoworkspace, 1"
        "$mod $shift, 2 ,  movetoworkspace, 2"
        "$mod $shift, 3 ,  movetoworkspace, 3"
        "$mod $shift, 4 ,  movetoworkspace, 4"
        "$mod $shift, 5 ,  movetoworkspace, 5"
        "$mod $shift, 6 ,  movetoworkspace, 6"
        "$mod $shift, 7 ,  movetoworkspace, 7"
        "$mod $shift, 8 ,  movetoworkspace, 8"
        "$mod $shift, 9 ,  movetoworkspace, 9"
        "$mod $shift, 0 ,  movetoworkspace, 10"

        "$mod, W, exec, waypaper"
      ];
        "bindel" = [

        " ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        " ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        " ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        " ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        " ,XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        " ,XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

    decoration = {
      "rounding" = 10;
      "rounding_power" = 2;

    # Change transparency of focused and unfocused windows
      "active_opacity" = 0.9;
      "inactive_opacity" = 0.7;

      "shadow" =  {
          "enabled" = true;
          "range" = 4;
          "render_power" = 3;
      };

    # https://wiki.hypr.land/Configuring/Variables/#blur
      "blur" = {
          "enabled" = true;
          "size" = 300;
          "passes" = 1;

          "vibrancy" = 0.8696;
         };
      };
    };
  };
}
