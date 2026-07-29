#######################################
#              NETWORK                #
#######################################
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  networking = {
    networkmanager = {
      enable = true;
    };

    hostName = "Nixtilus";
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
  };
  services.openssh = {
    enable = true;
  };
}
