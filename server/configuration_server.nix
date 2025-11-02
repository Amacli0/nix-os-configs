{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../modules/common.nix
    ./services/ddns.nix
  ];


boot = {
kernelPackages = pkgs.linuxPackages_latest;

 loader = {
 systemd-boot.enable = true;

 timeout = 15;
 };

 };
  sops.defaultSopsFile = ../secrets/main2.yaml;
   sops.age.keyFile = "~/secrets/new_age_key.txt";










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
