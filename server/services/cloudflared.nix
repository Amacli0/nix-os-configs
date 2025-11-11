{
  config,
  pkgs,
  ...
}: {
  services.cloudflared = {
    enable = true;

    tunnels."mini-ana" = {
      credentialsFile = "/var/lib/cloudflared/mini-tunnel.json";

      ingress = {
        hostname = "terraria.deepshell.org"; # Cloudflare'deki alan adın
        service = "tcp://127.0.0.1:7777"; # Yerel Terraria sunucunun portu
      };

      default = "http_status:404";
    };
  };
}
