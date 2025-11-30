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
  
  # Swap partition (nvme0n1p3)
  swapDevices = [
    { device = "/dev/disk/by-uuid/3cb59df9-d2df-451e-ae17-dcd22e82361a"; }
  ];
  
  # Hibernate için resume device
  boot.resumeDevice = "/dev/disk/by-uuid/3cb59df9-d2df-451e-ae17-dcd22e82361a";
  
  # Kernel parametreleri (swap partition için offset gerekmez)
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
