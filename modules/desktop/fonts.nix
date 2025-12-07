#######################################
#               FONT                  #
#######################################
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  fonts.packages = with pkgs; [
    monocraft
    nerd-fonts.fira-code
  ];

  fonts.fontconfig.enable = true;
}
