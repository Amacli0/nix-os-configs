#######################################
#            KULLANICILAR             #
#######################################
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  users.users.server-pc = {
    shell = pkgs.bash;
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "tailscale" "podman" "docker"];
  };
  #######################################
  #            HOME MANAGER             #
  #######################################
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "server-pc" = ../home-server.nix;
    };
  };
}
