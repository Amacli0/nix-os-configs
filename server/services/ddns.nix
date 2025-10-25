{ config, lib, pkgs, ... }:
{
  # Cloudflare DDNS - Custom script (daha esnek)
  systemd.services.cloudflare-ddns = {
    description = "Cloudflare Dynamic DNS Updater";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = config.sops.secrets.cloudflare-ddns-env.path;
    };
    
    script = ''
      # Mevcut public IP'yi al
      CURRENT_IP=$(${pkgs.curl}/bin/curl -s https://api.ipify.org)
      
      if [ -z "$CURRENT_IP" ]; then
        echo "Failed to get current IP"
        exit 1
      fi
      
      echo "Current IP: $CURRENT_IP"
      
      # Cloudflare Zone ID ve API Token (SOPS'tan gelecek)
      ZONE_ID="$CF_ZONE_ID"
      API_TOKEN="$CF_API_TOKEN"
      
      # Güncellenecek subdomain'ler
      RECORDS=("blog" "cloud" "vault" "status" "git" "metrics" "rss" "pdf" "ntfy" "netdata")
      
      for RECORD in "''${RECORDS[@]}"; do
        DOMAIN="$RECORD.deepshell.org"
        
        # Record ID'yi al
        RECORD_ID=$(${pkgs.curl}/bin/curl -s -X GET \
          "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$DOMAIN" \
          -H "Authorization: Bearer $API_TOKEN" \
          -H "Content-Type: application/json" | ${pkgs.jq}/bin/jq -r '.result[0].id')
        
        if [ "$RECORD_ID" = "null" ] || [ -z "$RECORD_ID" ]; then
          echo "Record not found for $DOMAIN, skipping..."
          continue
        fi
        
        # IP'yi güncelle
        RESPONSE=$(${pkgs.curl}/bin/curl -s -X PUT \
          "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
          -H "Authorization: Bearer $API_TOKEN" \
          -H "Content-Type: application/json" \
          --data "{\"type\":\"A\",\"name\":\"$DOMAIN\",\"content\":\"$CURRENT_IP\",\"ttl\":1,\"proxied\":true}")
        
        SUCCESS=$(echo "$RESPONSE" | ${pkgs.jq}/bin/jq -r '.success')
        
        if [ "$SUCCESS" = "true" ]; then
          echo "✓ Updated $DOMAIN to $CURRENT_IP"
        else
          echo "✗ Failed to update $DOMAIN"
          echo "$RESPONSE" | ${pkgs.jq}/bin/jq '.'
        fi
      done
    '';
  };

  # Timer - her 5 dakikada çalıştır
  systemd.timers.cloudflare-ddns = {
    description = "Run Cloudflare DDNS updater every 5 minutes";
    wantedBy = [ "timers.target" ];
    
    timerConfig = {
      OnBootSec = "2min";       # Boot'tan 2 dk sonra ilk çalıştır
      OnUnitActiveSec = "5min"; # Sonra her 5 dakika
      Persistent = true;
    };
  };

  # Gerekli paketler
  environment.systemPackages = with pkgs; [
    curl
    jq
  ];
}
