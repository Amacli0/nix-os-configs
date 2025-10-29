{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../modules/common.nix
  ];


boot = {
kernelPackages = pkgs.linuxPackages_latest;

 loader = {
 systemd-boot.enable = true;

 timeout = 15;
 };

 };
 










  networking.hostName = "server-pc";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 80 443 8080];

    allowedUDPPorts = [41641];
  };


users.users.server-pc = {
isNormalUser = true;
extraGroups = ["wheel" "networkmanager" "docker" "podman" ];




};









  system.stateVersion = "25.05";
}
