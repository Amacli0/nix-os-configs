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
        "terraria.deepshell.org" = "tcp://100.66.96.36:7777";
        "n8n.deepshell.org" = "http://100.66.36:8082";
      };
      default = "http_status:404";
    };
  };
}
