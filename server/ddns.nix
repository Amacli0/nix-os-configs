# configuration.nix veya ayrı bir modül dosyası

{ config, pkgs, ... }:

let
  # Secrets dosyasını import et (Git'e eklenmeyecek)
  secrets = import ./secrets.nix;
in
{
  # Cloudflare DDNS için systemd servisi
  systemd.services.cloudflare-ddns = {
    description = "Cloudflare DDNS Updater";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    # Her 5 dakikada bir çalıştır
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash ${pkgs.writeScript "cloudflare-ddns.sh" ''
        #!${pkgs.bash}/bin/bash
        set -e

        # Cloudflare API bilgileri
        ZONE_ID="${secrets.cloudflare.zoneId}"
        API_TOKEN="${secrets.cloudflare.apiToken}"
        DOMAIN="${secrets.cloudflare.domain}"
        RECORD_NAME="${secrets.cloudflare.recordName}"

        # Mevcut public IP'yi al
        CURRENT_IP=$(${pkgs.curl}/bin/curl -s https://api.ipify.org)
        
        # Cloudflare'deki mevcut IP'yi kontrol et
        RECORD_ID=$(${pkgs.curl}/bin/curl -s -X GET \
          "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$RECORD_NAME" \
          -H "Authorization: Bearer $API_TOKEN" \
          -H "Content-Type: application/json" | \
          ${pkgs.jq}/bin/jq -r '.result[0].id')

        CLOUDFLARE_IP=$(${pkgs.curl}/bin/curl -s -X GET \
          "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
          -H "Authorization: Bearer $API_TOKEN" \
          -H "Content-Type: application/json" | \
          ${pkgs.jq}/bin/jq -r '.result.content')

        # IP değiştiyse güncelle
        if [ "$CURRENT_IP" != "$CLOUDFLARE_IP" ]; then
          echo "IP değişti: $CLOUDFLARE_IP -> $CURRENT_IP"
          
          ${pkgs.curl}/bin/curl -s -X PUT \
            "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
            -H "Authorization: Bearer $API_TOKEN" \
            -H "Content-Type: application/json" \
            --data "{\"type\":\"A\",\"name\":\"$RECORD_NAME\",\"content\":\"$CURRENT_IP\",\"ttl\":120,\"proxied\":false}"
          
          echo "DNS kaydı güncellendi!"
        else
          echo "IP değişmedi: $CURRENT_IP"
        fi
      ''}";
    };
  };

  # Timer - Her 5 dakikada bir çalışır
  systemd.timers.cloudflare-ddns = {
    description = "Cloudflare DDNS Update Timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "5min";
      Unit = "cloudflare-ddns.service";
    };
  };

  # Gerekli paketler
  environment.systemPackages = with pkgs; [
    curl
    jq
  ];
}
