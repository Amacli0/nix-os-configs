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
virtualisation.docker.enable = true;

boot = {
kernelPackages = pkgs.linuxPackages_latest;

kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

 loader = {
 systemd-boot.enable = true;

 timeout = 15;
 };

 };
  sops.defaultSopsFile = ../secrets/main2.yaml;
   sops.age.keyFile = "~/secrets/new_age_key.txt";







  networking.hostName = "server-pc";

users.users.server-pc = {
isNormalUser = true;
extraGroups = ["networkmanager" "wheel" "tailscale" "podman" "docker"];



};
networking.firewall = {
  enable = true;
  # SSH, HTTP ve HTTPS portlarını aç
  allowedTCPPorts = [ 22 80 443 8080];
    trustedInterfaces = [ "tailscale0" ];
  allowedUDPPorts = [ 41641 ];
};


  services.openssh= {
  enable = true;
};


#services.nginx.enable = true;



services.tailscale = {
  enable = true;


};

networking.networkmanager.dns = "none";







  system.stateVersion = "25.05";
}
