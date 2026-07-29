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

  services.netbird.enable = true;
  environment.systemPackages = [pkgs.netbird-ui];

  services = {
    dnscrypt-proxy = {
      enable = true;
      settings = {
        listen_addresses = [
          "127.0.0.1:53"
          "[::1]:53"
        ];
      };
    };

    zapret = {
      enable = true;
      params = [
        "--dpi-desync=fake"
        "--dpi-desync-repeats=6"
        "--dpi-desync-fooling=md5sig"
        # TTL değerini siliyoruz, otomatik hesaplaması için:
        "--dpi-desync-autottl=2" # Başlangıçta 2 hop dener, DPI bulana kadar artırır
        "--dpi-desync-any-protocol"
        "--dpi-desync-cutoff=d4"
      ];
    };

    tailscale = {
      enable = true;
    };

    openssh = {
      enable = true;
    };
  };
}
