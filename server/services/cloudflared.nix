{
  config,
  pkgs,
  ...
}: {
  services.cloudflared = {
    enable = true;

    tunnels."mini-ana" = {
      credentialsFile = "/var/lib/cloudflared/mini-tunnel.json";

      # ingress bir liste (array) olmalı — her kural bir attrset olarak
      ingress = [
        {
          hostname = "terraria.deepshell.org";
          service = "tcp://127.0.0.1:7777";
        }
        {
          service = "http_status:404";
        }
      ];
    };
  };
}
