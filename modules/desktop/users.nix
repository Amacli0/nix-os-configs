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
  services.udev.packages = with pkgs; [platformio-core.udev];
  users.users.deepshell = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "libvirtd"
      "kvm"
      "lp"
      "lpadmin"
      "docker"
      "podman"
      "eno1"
      "dialout"
      "plugdev"
      "tty"
      "plugdev"
    ];
  };
  users.users.softshell = {
    shell = pkgs.bash;
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "users"
    ];
  };
  #######################################
  #            HOME MANAGER             #
  #######################################
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "deepshell" = ../../main/home.nix;
      "softshell" = ../../main/home-soft.nix;
    };
  };
  environment.shells = [pkgs.zsh];
  programs.zsh.enable = true;
}
