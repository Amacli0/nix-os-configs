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

  swapDevices = [
    {device = "/dev/disk/by-uuid/3cb59df9-d2df-451e-ae17-dcd22e82361a";}
  ];

  boot.resumeDevice = "/dev/disk/by-uuid/3cb59df9-d2df-451e-ae17-dcd22e82361a";

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
