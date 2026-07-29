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
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    font-awesome
    material-design-icons
  ];

  fonts.fontconfig.enable = true;

  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
}
