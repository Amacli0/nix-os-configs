#######################################
#              HARDWARE               #
#######################################
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  services = {
    xserver.videoDriver = [ "amdgpu" ];
    tlp = {
      enable = true;
    };
    libinput.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };

  };
  hardware = {
    bluetooth.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
