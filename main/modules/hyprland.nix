{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.hyprland;

    extraConfig = ''
      exec-once = hyprpolkitagent
    '';

    settings = {
      "$mod" = "SUPER";
      "$alt" = "Alt";
      "$space" = "SPACE";
      "$control" = "CTRL";
      "$shift" = "SHIFT";
      "$terminal" = "kitty";
      "$menu" = "rofi";

      exec-once = [
        "${pkgs.waybar}/bin/waybar"
        "swww-daemon"
        "hyprpolkitagent"
      ];

      "monitor" = "eDP-1, 1920x1080@144, 0x0, 1";

      general = {
        "layout" = "dwindle";
        "gaps_in" = 5;
        "gaps_out" = 10;
        "border_size" = 2;
      };

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
    };
  };
}
