{ config, lib, pkgs, ... }:
{
  # Docker
  virtualisation.docker = {
    enable = true;
    
    # Storage driver
    storageDriver = "overlay2";
    
    # Performance & security
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
    };
    
    # Daemon settings
    daemon.settings = {
      # Log rotation
      log-driver = "json-file";
      log-opts = {
        max-size = "10m";
        max-file = "3";
      };
      
      # Performance
      default-ulimits = {
        nofile = {
          Hard = 64000;
          Name = "nofile";
          Soft = 64000;
        };
      };
    };
  };

  # Docker compose dizinleri
  systemd.tmpfiles.rules = [
    "d /opt/docker 0755 root root -"
    "d /opt/docker/ghost 0755 root root -"
    "d /opt/docker/freshrss 0755 root root -"
    "d /opt/docker/uptime-kuma 0755 root root -"
    "d /opt/docker/stirling-pdf 0755 root root -"
    "d /opt/docker/ntfy 0755 root root -"
  ];

  # Docker network setup
  systemd.services.docker-network-setup = {
    description = "Create Docker Networks";
    after = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    
    script = ''
      ${pkgs.docker}/bin/docker network create web || true
    '';
  };

  # Docker prune service
  systemd.services.docker-prune = {
    description = "Cleanup Docker resources";
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      ${pkgs.docker}/bin/docker system prune -af --volumes
    '';
  };

  systemd.timers.docker-prune = {
    description = "Cleanup Docker resources weekly";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

  # Ghost Blog
  systemd.services.docker-ghost = {
    description = "Ghost Blog Docker Container";
    after = [ "docker.service" "docker-network-setup.service" "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      WorkingDirectory = "/opt/docker/ghost";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
      Restart = "on-failure";
    };
  };

  # FreshRSS
  systemd.services.docker-freshrss = {
    description = "FreshRSS Docker Container";
    after = [ "docker.service" "docker-network-setup.service" "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      WorkingDirectory = "/opt/docker/freshrss";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
      Restart = "on-failure";
    };
  };

  # Uptime Kuma
  systemd.services.docker-uptime-kuma = {
    description = "Uptime Kuma Monitoring";
    after = [ "docker.service" "docker-network-setup.service" "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      WorkingDirectory = "/opt/docker/uptime-kuma";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
      Restart = "on-failure";
    };
  };

  # Stirling PDF
  systemd.services.docker-stirling-pdf = {
    description = "Stirling PDF Tools";
    after = [ "docker.service" "docker-network-setup.service" "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      WorkingDirectory = "/opt/docker/stirling-pdf";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
      Restart = "on-failure";
    };
  };

  # Ntfy
  systemd.services.docker-ntfy = {
    description = "Ntfy Push Notifications";
    after = [ "docker.service" "docker-network-setup.service" "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      WorkingDirectory = "/opt/docker/ntfy";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
      Restart = "on-failure";
    };
  };
}
