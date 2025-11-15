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
  users.users.deepshell = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "audio" "video" "libvirt" "kvm" "lp"];
  };
  users.users.softshell = {
    shell = pkgs.bash;
    isNormalUser = true;
    extraGroups = ["networkmanager" "users"];
  };
  #######################################
  #            HOME MANAGER             #
  #######################################
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "deepshell" = ../home.nix;
      "softshell" = ../home-soft.nix;
    };
  };
  environment.shells = [pkgs.zsh];
  programs.zsh.enable = true;
}
