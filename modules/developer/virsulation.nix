#######################################
#            SANALLAŞTIRMA            #
#######################################
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  virtualisation = {
    spiceUSBRedirection.enable = true;

    libvirtd = {
      enable = true;
      qemuPackage = pkgs.qemu_kvm;
      onBoot = "start";
      onShutdown = "shutdown";
    };
  };
  programs = {
    virt-manager.enable = true;
  };
}
