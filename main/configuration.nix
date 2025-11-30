{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  #######################################
  #            IMPORTS                  #
  #######################################
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    ###
    ../modules/system/boot.nix
    ../modules/system/network.nix
    ../modules/system/hardware.nix
    ../modules/system/keyboard.nix
    ../modules/system/security.nix
    ../modules/system/system-packages.nix
    ####
    ../modules/desktop/main.nix
    ../modules/desktop/fonts.nix
    ../modules/desktop/users.nix
    ../modules/desktop/main.nix
    ../modules/desktop/gaming.nix
    ../modules/desktop/stylinx.nix
    ###
    ../modules/developer/virsulation.nix
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "25.05";
}
