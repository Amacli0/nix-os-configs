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
 boot.resumeDevice = "/dev/disk/by-uuid/2038d2a6-83ca-4c99-ae68-1cbab02ca766";
  swapDevices = [{device = "/dev/disk/by-uuid/2038d2a6-83ca-4c99-ae68-1cbab02ca766";}];

  boot.kernelPackages = pkgs.linuxPackages_latest;

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
