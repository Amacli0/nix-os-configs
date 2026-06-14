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
    podman.enable = true;
    waydroid.enable = true;
    docker.enable = true;
    lxc.enable = true;
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
