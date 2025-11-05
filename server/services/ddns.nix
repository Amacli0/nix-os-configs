{
  config,
  pkgs,
  ...
}: {
  sops.secrets.cloudflare-ddns = {
    sopsFile = ../../secrets/main.yaml; # veya main2.yaml
    owner = "cloudflare-ddns";
    group = "cloudflare-ddns";
  };

  users.users.cloudflare-ddns = {
    isSystemUser = true;
    group = "cloudflare-ddns";
  };

  users.groups.cloudflare-ddns = {};

  systemd.services.cloudflare-ddns = {
    description = "Cloudflare DDNS Updater";
    after = ["network-online.target"];
    wants = ["network-online.target"];

    serviceConfig = {
      Type = "oneshot";
      User = "cloudflare-ddns";
      Group = "cloudflare-ddns";
      ExecStart = pkgs.writeShellScript "cloudflare-ddns-update" ''
        set -euo pipefail

        # Secrets dosyasından bilgileri oku
        . ${config.sops.secrets.cloudflare-ddns.path}

        # Mevcut IP'yi al
        CURRENT_IP=$(${pkgs.curl}/bin/curl -s https://api.ipify.org)

        # Cloudflare'den mevcut DNS kaydını al
        RECORD_IP=$(${pkgs.curl}/bin/curl -s -X GET \
          "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$DOMAIN" \
          -H "Authorization: Bearer $API_TOKEN" \
          -H "Content-Type: application/json" | ${pkgs.jq}/bin/jq -r '.result[0].content')

        RECORD_ID=$(${pkgs.curl}/bin/curl -s -X GET \
          "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$DOMAIN" \
          -H "Authorization: Bearer $API_TOKEN" \
          -H "Content-Type: application/json" | ${pkgs.jq}/bin/jq -r '.result[0].id')

        # IP değişmişse güncelle
        if [ "$CURRENT_IP" != "$RECORD_IP" ]; then
          ${pkgs.curl}/bin/curl -s -X PUT \
            "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
            -H "Authorization: Bearer $API_TOKEN" \
            -H "Content-Type: application/json" \
            --data "{\"type\":\"A\",\"name\":\"$DOMAIN\",\"content\":\"$CURRENT_IP\",\"ttl\":120,\"proxied\":false}"
          echo "IP güncellendi: $RECORD_IP -> $CURRENT_IP"
        else
          echo "IP değişmemiş: $CURRENT_IP"
        fi
      '';
    };
  };

  systemd.timers.cloudflare-ddns = {
    description = "Cloudflare DDNS Update Timer";
    wantedBy = ["timers.target"];

    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "5min";
      Unit = "cloudflare-ddns.service";
    };
  };

  environment.systemPackages = with pkgs; [curl jq];
}
