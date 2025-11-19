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
boot.initrd.luks.devices."cryptroot".swap.uuid = "cd8cc7c6-4a37-4a5a-95a7-f40d6fa744b2";
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
