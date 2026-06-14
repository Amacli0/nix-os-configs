#######################################
#              HARDWARE               #
#######################################
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  security.rtkit.enable = true;

  services = {
    xserver.videoDriver = ["amdgpu"];
    tlp = {
      enable = true;
    };
    libinput.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      jack.enable = true;
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
