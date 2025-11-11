{
  config,
  lib,
  pkgs,
  ...
}: {
  #######################################
  #              IMPORTS              #
  #######################################
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    inputs.home-manager.nixosModules.home-manager
    ./services/podman.nix
    ./services/terraria.nix
    ./services/cloudflared.nix

    ./modules/boot.nix
    ./modules/ollama.nix
    ./modules/packages.nix
    ./modules/security.nix
    ./modules/sops.nix
    ./modules/users.nix
  ];

  system.stateVersion = "25.05";
}
