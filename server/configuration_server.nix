{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ../modules/common.nix
    ];


  networking.hostName = "server-pc"; 


  

networking.firewall = {
  enable = true;
  allowedTCPPorts = [ 22 80 443 8080];

  allowedUDPPorts = [ 41641 ];
};


system.stateVersion = "25.05"; 

}
