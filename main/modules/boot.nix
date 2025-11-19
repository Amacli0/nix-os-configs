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

# Swap partition
swapDevices = [
  { device = "/dev/disk/by-uuid/2038d2a6-83ca-4c99-ae68-1cbab02ca766"; }
];

# Hibernate (resume) cihazı
boot.resumeDevice = "/dev/disk/by-uuid/2038d2a6-83ca-4c99-ae68-1cbab02ca766";

# kernel parametreleri boş
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
