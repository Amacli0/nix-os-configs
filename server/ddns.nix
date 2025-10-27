{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix;

  envFile = pkgs.writeText "cloudflare.env" ''
    ZONE_ID=${secrets.cloudflare.zoneId}
    API_TOKEN=${secrets.cloudflare.apiToken}
    DOMAIN=${secrets.cloudflare.domain}
    RECORD_NAME=${secrets.cloudflare.recordName}
  '';
in
{
  systemd.services.cloudflare-ddns = {
    description = "Cloudflare DDNS Updater";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = "${envFile}";
      ExecStart = "${pkgs.bash}/bin/bash ${config.system.build.toplevel}/server/cloudflare-ddns.sh";
    };
  };

  systemd.timers.cloudflare-ddns = {
    description = "Cloudflare DDNS Update Timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "5min";
      Unit = "cloudflare-ddns.service";
    };
  };

  environment.systemPackages = with pkgs; [
    curl
    jq
  ];
}

