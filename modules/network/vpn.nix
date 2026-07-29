{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  services = {
    netbird.enable = true;

    tailscale.enable = true;
  };

  environment.systemPackages = [pkgs.netbird-ui];
}
