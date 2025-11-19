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
  boot.kernelParams = ["resume_offset=269568"];
boot.resumeDevice = "/dev/disk/by-uuid/cd8cc7c6-4a37-4a5a-95a7-f40d6fa744b2";
  swapDevices = [{device = "/swap/swapfile";}];
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
