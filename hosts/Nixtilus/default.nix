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
    ./hardware-configuration.nix

    # Sistem Modülleri
    ../../modules/system

    # Desktop Modülleri
    ../../modules/desktop

    # Developer Modülleri
    ../../modules/developer

    # Network Modulleri
    ../../modules/network
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.05";
}
