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
    inputs.home-manager.nixosModules.home-manager
    ./modules/boot.nix
    ./modules/desktop.nix
    ./modules/fonts.nix
    ./modules/gaming.nix
    ./modules/hardware.nix
    ./modules/network.nix
    ./modules/security.nix
    ./modules/stylinx.nix
    ./modules/users.nix
    ./modules/virsulation.nix
  ];

  system.stateVersion = "25.05";
}
