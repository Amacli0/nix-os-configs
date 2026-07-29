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
    searx = {
      enable = true;
      settings = {
        server.port = 8888;
        server.bind_address = "127.0.0.1";
        server.secret_key = config.sops.secrets.searx_secret_key.path; # Buraya rastgele uzun bir yazı yaz
        ui.static_use_hash = true;
        search.formats = ["html" "json"];
        engines = [
          {
            name = "google";
            engine = "google";
            shortcut = "g";
          }
          {
            name = "duckduckgo";
            engine = "duckduckgo";
            shortcut = "d";
          }
          {
            name = "wikipedia";
            engine = "wikipedia";
            shortcut = "w";
          }
          {
            name = "wikidata";
            engine = "wikidata";
          }
        ];
      };
    };
  };
}
