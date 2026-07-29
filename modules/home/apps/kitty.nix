#######################################
#            KİTTY                    #
#######################################
{
  config,
  pkgs,
  lib,
  ...
}: {
  programs = {
    kitty = {
      enable = false;
      settings = {
        confirm_os_window_close = -1;
      };
      font = {
        name = lib.mkForce "Monocraft";
        size = 12;
      };
    };
  };
}
