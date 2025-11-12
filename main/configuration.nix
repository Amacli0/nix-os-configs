{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  #######################################
  #            IMPORTS                  #
  #######################################
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ./modules/stylinx.nix
    inputs.home-manager.nixosModules.home-manager
    ./modules/boot.nix
    ./modules/desktop.nix
    ./modules/fonts.nix
    ./modules/gaming.nix
    ./modules/hardware.nix
    ./modules/network.nix
    ./modules/security.nix
    ./modules/users.nix
    ./modules/virsulation.nix
  ];
  environment.systemPackages = with pkgs; [
    #her şeyin ölme ihtimaline karşı önlemler
    kitty
    firefox
    vscodium
  ];
  system.stateVersion = "25.05";
}
