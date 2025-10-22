
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
   networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

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




users.users.server-pc = {
isNormalUser = true;
extraGroups = ["whell" "networkmanager"];



};







   services.openssh.enable = true;

  system.stateVersion = "25.05"; 

}

