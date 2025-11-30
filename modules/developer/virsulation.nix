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
      qemu.package = pkgs.qemu_kvm;
      onBoot = "start";
      onShutdown = "shutdown";
    };
  };
  programs = {
    virt-manager.enable = true;
  };
}
