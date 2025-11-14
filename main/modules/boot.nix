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
  boot = {
    sysctl = {
  "net.ipv4.ip_forward" = 1;
};
    kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
    ];
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      timeout = 15;

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
  };
}
