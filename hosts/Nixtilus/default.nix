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
    ../../modules/system/boot.nix
    ../../modules/system/network.nix
    ../../modules/system/hardware.nix
    ../../modules/system/keyboard.nix
    ../../modules/system/security.nix
    ../../modules/system/system-packages.nix

    # Desktop Modülleri
    ../../modules/desktop/main.nix
    ../../modules/desktop/fonts.nix
    ../../modules/desktop/users.nix
    ../../modules/desktop/gaming.nix
    ../../modules/desktop/stylix.nix
    ../../modules/desktop/printer.nix

    # Developer Modülleri
    ../../modules/developer/virtualisation.nix
    ../../modules/developer/sdr.nix
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.rpcbind.enable = true;
  boot.supportedFilesystems = ["nfs"];

  services.netbird.enable = true;
  environment.systemPackages = [pkgs.netbird-ui];

  system.stateVersion = "25.05";
}
