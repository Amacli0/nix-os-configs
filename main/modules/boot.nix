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
  boot.kernelParams = ["resume_offsets=533760"];
  boot.resumeDevice = "/dev/mapper/cryptroot";
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
