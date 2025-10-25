{ config, lib, pkgs, ... }:
{
  # Uptime Kuma - Service Monitoring
  # Not: NixOS'ta native module yok, Docker ile ekleyeceğiz
  # Ama şimdilik placeholder bırakalım
  
  # Prometheus - Metrics Collection
  services.prometheus = {
    enable = true;
    port = 9090;
    
    # Retention (240GB disk için 30 gün yeterli)
    retentionTime = "30d";
    
    exporters = {
      # Node exporter - sistem metrikleri
      node = {
        enable = true;
        port = 9100;
        enabledCollectors = [
          "systemd"
          "processes"
          "cpu"
          "diskstats"
          "filesystem"
          "loadavg"
          "meminfo"
          "netdev"
          "netstat"
        ];
      };
      
      # PostgreSQL exporter
      postgres = {
        enable = true;
        port = 9187;
        dataSourceName = "user=postgres database=postgres host=/run/postgresql sslmode=disable";
      };
      
      # Nginx/Caddy exporter (opsiyonel)
      # nginx = {
      #   enable = true;
      #   port = 9113;
      # };
    };
    
    # Scrape configs
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [{
          targets = [ "localhost:9100" ];
        }];
      }
      {
        job_name = "postgresql";
        static_configs = [{
          targets = [ "localhost:9187" ];
        }];
      }
      {
        job_name = "caddy";
        static_configs = [{
          targets = [ "localhost:2019" ];  # Caddy metrics endpoint
        }];
      }
    ];
  };

  # Grafana - Visualization
  services.grafana = {
    enable = true;
    
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3002;
        domain = "metrics.deepshell.org";
        root_url = "https://metrics.deepshell.org";
      };
      
      # Security
      security = {
        admin_user = "admin";
        admin_password = "$__file{${config.sops.secrets.grafana-admin-password.path}}";
        secret_key = "$__file{${config.sops.secrets.grafana-secret-key.path}}";
      };
      
      # Analytics
      analytics.reporting_enabled = false;
      
      # Auth
      "auth.anonymous" = {
        enabled = false;
      };
    };
    
    # Datasources
    provision = {
      enable = true;
      
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "http://localhost:9090";
          isDefault = true;
        }
      ];
      
      # Pre-configured dashboards
      dashboards.settings.providers = [
        {
          name = "default";
          options.path = "/var/lib/grafana/dashboards";
        }
      ];
    };
  };

  # Loki - Log Aggregation (opsiyonel ama data engineer için çok faydalı)
  services.loki = {
    enable = true;
    
    configuration = {
      server.http_listen_port = 3100;
      
      auth_enabled = false;
      
      ingester = {
        lifecycler = {
          address = "127.0.0.1";
          ring = {
            kvstore.store = "inmemory";
            replication_factor = 1;
          };
        };
        chunk_idle_period = "5m";
        chunk_retain_period = "30s";
      };
      
      schema_config = {
        configs = [{
          from = "2024-01-01";
          store = "boltdb-shipper";
          object_store = "filesystem";
          schema = "v11";
          index = {
            prefix = "index_";
            period = "24h";
          };
        }];
      };
      
      storage_config = {
        boltdb_shipper = {
          active_index_directory = "/var/lib/loki/index";
          cache_location = "/var/lib/loki/cache";
          shared_store = "filesystem";
        };
        filesystem.directory = "/var/lib/loki/chunks";
      };
      
      limits_config = {
        reject_old_samples = true;
        reject_old_samples_max_age = "168h"; # 7 days
        retention_period = "30d";
      };
      
      compactor = {
        working_directory = "/var/lib/loki/compactor";
        shared_store = "filesystem";
        retention_enabled = true;
      };
    };
  };

  # Promtail - Log shipper for Loki
  services.promtail = {
    enable = true;
    
    configuration = {
      server = {
        http_listen_port = 9080;
        grpc_listen_port = 0;
      };
      
      positions.filename = "/var/lib/promtail/positions.yaml";
      
      clients = [{
        url = "http://localhost:3100/loki/api/v1/push";
      }];
      
      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = "server-pc";
            };
          };
          relabel_configs = [
            {
              source_labels = [ "__journal__systemd_unit" ];
              target_label = "unit";
            }
            {
              source_labels = [ "__journal_priority" ];
              target_label = "priority";
            }
          ];
        }
        {
          job_name = "caddy";
          static_configs = [{
            targets = [ "localhost" ];
            labels = {
              job = "caddy";
              __path__ = "/var/log/caddy/*.log";
            };
          }];
        }
      ];
    };
  };

  # Netdata - Real-time monitoring (lightweight alternative)
  services.netdata = {
    enable = true;
    
    config = {
      global = {
        "default port" = "19999";
        "bind to" = "127.0.0.1";
      };
      
      web = {
        "allow connections from" = "localhost";
      };
    };
  };

  # Grafana dashboard'ları için
  environment.systemPackages = with pkgs; [
    grafana
  ];

  # Monitoring için firewall (sadece local erişim)
  networking.firewall.interfaces.lo.allowedTCPPorts = [
    9090  # Prometheus
    3100  # Loki
    19999 # Netdata
  ];
}
