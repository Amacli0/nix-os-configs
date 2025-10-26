{ config, lib, pkgs, ... }:
{
  # ============================================
  # SOPS SECRETS - Root dizindeki secrets.yaml'dan
  # ============================================
  sops.secrets = {
    cloudflare_email = {
      sopsFile = ../../secrets.yaml;  # server/ → nixos-flake-config/ → secrets.yaml
    };
    cloudflare_api_token = {
      sopsFile = ../../secrets.yaml;
    };
    wireguard_private_key = {
      sopsFile = ../../secrets.yaml;
    };
  };

  # ... geri kalan ayarlar aynı
  # (Cloudflare DDNS, Tailscale, WireGuard kodları değişmedi)
  
  systemd.services.cloudflare-ddns = {
    description = "Cloudflare DDNS Updater";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    startAt = "*:0/5";
    
    serviceConfig = {
      Type = "oneshot";
    };
    
    script = ''
      EMAIL=$(cat ${config.sops.secrets.cloudflare_email.path})
      TOKEN=$(cat ${config.sops.secrets.cloudflare_api_token.path})
      
      CURRENT_IP=$(${pkgs.curl}/bin/curl -s https://api.ipify.org)
      
      ZONE_ID=$(${pkgs.curl}/bin/curl -s -X GET \
        "https://api.cloudflare.com/client/v4/zones?name=deepshell.org" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" | \
        ${pkgs.jq}/bin/jq -r '.result[0].id')
      
      RECORD_ID=$(${pkgs.curl}/bin/curl -s -X GET \
        "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=deepshell.org&type=A" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" | \
        ${pkgs.jq}/bin/jq -r '.result[0].id')
      
      ${pkgs.curl}/bin/curl -s -X PUT \
        "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        --data "{\"type\":\"A\",\"name\":\"deepshell.org\",\"content\":\"$CURRENT_IP\",\"ttl\":120,\"proxied\":false}"
      
      echo "$(date): IP updated to $CURRENT_IP"
    '';
  };

  services.tailscale.enable = true;

  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.100.0.1/24" ];
    listenPort = 51820;
    privateKeyFile = config.sops.secrets.wireguard_private_key.path;
    peers = [];
    
    postSetup = ''
      ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
    '';
    
    postShutdown = ''
      ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT || true
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE || true
    '';
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
    jq
  ];
}
