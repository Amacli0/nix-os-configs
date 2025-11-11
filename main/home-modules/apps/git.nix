#######################################
#                GİT                  #
#######################################
{
  config,
  pkgs,
  lib,
  ...
}: {
  programs = {
    git = {
      enable = true;
      settings = {
        user.name = "Mehmet Şükrü Bilgiç";
        user.email = "deepshell@proton.me";
      };
    };
  };
}
