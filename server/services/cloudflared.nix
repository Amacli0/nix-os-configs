{
  config,
  pkgs,
  ...
}: {
  services.cloudflared = {
    enable = true;

    tunnels."mini-ana" = {
      credentialsFile = "/var/lib/cloudflared/mini-tunnel.json";

      # ingress bir attribute set olmalı: hostname → service
      ingress = {
        "**tcp://terraria.deepshell.org**" = "tcp://100.66.96.36:7777";
      };

      # default için 404 eklemek istersen cloudflared modülüne göre ayrı seçenek vardır.
      # Eğer modül bunu destekliyorsa default = "http_status:404"; ekleyebilirsin
      default = "http_status:404";
    };
  };
}
