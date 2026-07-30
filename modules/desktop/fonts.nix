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
    proggyfonts
    terminus_font
    monocraft
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    font-awesome
    material-design-icons
  ];

  fonts.fontconfig.enable = true;

  environment.systemPackages = with pkgs; [
    papirus-icon-theme
  ];
}
