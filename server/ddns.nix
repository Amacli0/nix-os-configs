{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix;

  # Bash script
  ddnsScript = pkgs.writeShellScript "cloudflare-ddns.sh" ''
    #!${pkgs.bash}/bin/bash
    set -e

    # Environment kontrolü
    if [ -z "$ZONE_ID" ]; then
      echo "ZONE_ID not set"
      exit 1
    fi
    if [ -z "$API_TOKEN" ]; then
      echo "API_TOKEN not set"
      exit 1
    fi
    if [ -z "$DOMAIN" ]; then
      echo "DOMAIN not set"
      exit 1
    fi
    if [ -z "$RECORD_NAME" ]; then
      echo "RECORD_NAME not set"
      exit 1
    fi

    # Public IP al
    CURRENT_IP=$(${pkgs.curl}/bin/curl -s https://api.ipify.org)

    # DNS record ID
    RECORD_ID=$(${pkgs.curl}/bin/curl -s -X GET \
      "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$RECORD_NAME" \
      -H "Authorization: Bearer $API_TOKEN" \
      -H "Content-Type: application/json" | ${pkgs.jq}/bin/jq -r '.result[0].id')

    # Cloudflare IP
    CLOUDFLARE_IP=$(${pkgs.curl}/bin/curl -s -X GET \
      "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
      -H "Authorization: Bearer $API_TOKEN" \
      -H "Content-Type: application/json" | ${pkgs.jq}/bin/jq -r '.result.content')

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
  '';
in
{
  # Systemd servisi
  systemd.services.cloudflare-ddns = {
    description = "Cloudflare DDNS Updater";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      Environment = ''
        ZONE_ID=${secrets.cloudflare.zoneId}
        API_TOKEN=${secrets.cloudflare.apiToken}
        DOMAIN=${secrets.cloudflare.domain}
        RECORD_NAME=${secrets.cloudflare.recordName}
      '';
      ExecStart = "${ddnsScript}";
    };
  };

  # Timer
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

