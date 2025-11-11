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
        "n8n.deepshell.org" = "http://localhost:8082";
      };
      default = "http_status:404";
    };
  };
}
