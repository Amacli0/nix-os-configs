{ config, pkgs, lib, ... }:


{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.hyprland;

    settings = {
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

      "monitor" = [
        "eDP-1, 1920x1080@144, 0x0, 1"
      ];
          "$mod" = "SUPER";
      "bind" =
        [
          "$mod, T, exec, kitty"
          "$mod, Q, killactive"
          "$mod SHIFT, M, exit"
          "$mod, F, fullscreen"
          "$mod, V, togglefloating"

          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod SHIFT, left, movewindow, l"
          "$mod SHIFT, right, movewindow, r"
          "$mod SHIFT, up, movewindow, u"
          "$mod SHIFT, down, movewindow, d"
        ]
        ++ lib.flatten (lib.genList (i:
          let ws = builtins.toString (i + 1);
          in [
            "$mod, ${ws}, workspace, ${ws}"
            "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
          ]
        ) 9);
    };
  };
}

