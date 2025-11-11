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
    hostName = "Nixtilus";
    nameservers = ["127.0.0.1" "::1"];
  };

  services = {
    dnscrypt-proxy = {
      enable = true;
      settings = {
        listen_addresses = ["127.0.0.1:53" "[::1]:53"];
      };
    };

    zapret = {
      enable = true;
      params = [
        "--dpi-desync=fake"
        "--dpi-desync-ttl=8"
      ];
    };
  };
}
