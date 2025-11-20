{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  #######################################
  #            IMPORTS                  #
  #######################################
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ./modules/stylinx.nix
    inputs.home-manager.nixosModules.home-manager
    ./modules/boot.nix
    ./modules/desktop.nix
    ./modules/fonts.nix
    ./modules/gaming.nix
    ./modules/hardware.nix
    ./modules/network.nix
    ./modules/security.nix
    ./modules/users.nix
    ./modules/virsulation.nix
    ./modules/nixvim.nix
    ./modules/power.nix
  ];

  environment.systemPackages = with pkgs; [
    #her şeyin ölme ihtimaline karşı önlemler
    kitty
    firefox
    vscodium
    papirus-icon-theme
  ];

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      brlaser # Açık kaynak Brother sürücüsü (HL-20'ye destek verme olasılığı var)
    ];
  };
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  boot.kernelParams = [
    "usbhid.quirks=0x0810:0x0001:0x040"
  ];
  boot.extraModprobeConfig = ''
    options usbhid quirks=0x0810:0x0001:0x040
  '';
  system.stateVersion = "25.05";
}
