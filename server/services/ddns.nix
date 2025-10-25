{ config, lib, pkgs, ... }:
{
  # Cloudflare DDNS - Dinamik IP güncelleme
  services.cloudflare-dyndns = {
    enable = true;
    
    # API token (sops'tan gelecek)
    apiTokenFile = config.sops.secrets.cloudflare-api-token.path;
    
    # Hangi domainleri güncelleyeceğiz
    domains = [
      "deepshell.org"           # Ana domain
      "*.deepshell.org"         # Tüm subdomainler (wildcard)
    ];
    
    # Her 5 dakikada bir kontrol et
    # (IP değişirse otomatik güncelle)
    proxied = true;  # Cloudflare proxy (orange cloud) aktif
  };

  # Alternatif: cloudflare-ddns script (daha esnek)
  systemd.services.cloudflare-ddns-custom = {
    description = "Cloudflare Dynamic DNS Updater";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      # SOPS secret'ı kullan
      EnvironmentFile = config.sops.secrets.cloudflare-ddns-env.path;
    };
    
    script = ''
      # Mevcut public IP'yi al
      CURRENT_IP=$(${pkgs.curl}/bin/curl -s https://api.ipify.org)
      
      # Cloudflare Zone ID ve API Token
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
        
        # IP'yi güncelle
        ${pkgs.curl}/bin/curl -s -X PUT \
          "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
          -H "Authorization: Bearer $API_TOKEN" \
          -H "Content-Type: application/json" \
          --data "{\"type\":\"A\",\"name\":\"$DOMAIN\",\"content\":\"$CURRENT_IP\",\"ttl\":1,\"proxied\":true}"
        
        echo "Updated $DOMAIN to $CURRENT_IP"
      done
    '';
  };

  # Timer - her 5 dakikada çalıştır
  systemd.timers.cloudflare-ddns-custom = {
    description = "Run Cloudflare DDNS updater every 5 minutes";
    wantedBy = [ "timers.target" ];
    
    timerConfig = {
      OnBootSec = "1min";     # Boot'tan 1 dk sonra ilk çalıştır
      OnUnitActiveSec = "5min"; # Sonra her 5 dakika
      Persistent = true;
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    curl
    jq  # JSON parsing için
  ];
}
