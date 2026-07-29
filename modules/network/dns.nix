{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
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
  };
}
