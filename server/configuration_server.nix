
{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "server-pc"; 
   networking.networkmanager.enable = true;  

   time.timeZone = "Europe/Istanbul";


 i18n.defaultLocale = "en_US.UTF-8";
 console = {
 keyMap = "trq";   
 font = "latarcyrheb-sun32";
   };


nix.settings = {
experimental-features = ["nix-command" "flakes" ];

};
  

environment.systemPackages = with pkgs; [
git     
neovim 
terminus_font
   ];

security.sudo = {
  enable = true; 
  extraRules = [
    {
      groups = [ "wheel" ]; 
      commands = [ "ALL" ];   

}
  ];
};
users.users.server-pc = {
isNormalUser = true;
extraGroups = ["networkmanager" "wheel"];



};

networking.firewall = {
  enable = true;
  # SSH, HTTP ve HTTPS portlarını aç
  allowedTCPPorts = [ 22 80 443 ]; 
};


  services.openssh= {
  enable = true;
settings = {  
  passwordAuthentication = false;
  permitRootLogin = "no";
 };
};


services.nginx.enable = true;



system.stateVersion = "25.05"; 

}

