#######################################
#                BOOT                 #
#######################################
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [];

  boot.loader = {
    timeout = 15;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
    systemd-boot = {
      enable = false;
    };
  };
}
