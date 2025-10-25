{ config, lib, pkgs, ... }:
{
  # PostgreSQL - Ana database
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    
    # Performance tuning (16GB RAM için)
    settings = {
      # Memory
      shared_buffers = "4GB";
      effective_cache_size = "12GB";
      maintenance_work_mem = "1GB";
      work_mem = "64MB";
      
      # Checkpoints
      checkpoint_completion_target = "0.9";
      wal_buffers = "16MB";
      
      # Connections
      max_connections = "100";
      
      # Query planning
      random_page_cost = "1.1";
      effective_io_concurrency = "200";
      
      # Logging (debugging için)
      log_line_prefix = "%t [%p]: [%l-1] user=%u,db=%d,app=%a,client=%h ";
      log_checkpoints = true;
      log_connections = true;
      log_disconnections = true;
      log_lock_waits = true;
      log_temp_files = 0;
    };
    
    # Databases
    ensureDatabases = [ 
      "ghost"
      "nextcloud"
      "gitea"
      "MyData"
    ];
    
    # Users
    ensureUsers = [
      {
        name = "ghost";
        ensureDBOwnership = true;
      }
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
      {
        name = "gitea";
        ensureDBOwnership = true;
      }

      {
	name = "MyData";
	ensureDBOwnership = true;

      }
    ];
    
    # Otomatik yedekleme
    # backup.enable = true;
  };

  # PostgreSQL monitoring için
  services.postgresql.enableTCPIP = true;
  
  # Caddy - Reverse Proxy (Otomatik SSL)
  services.caddy = {
    enable = true;
    email = "deepshell@proton.me";  # Değiştir!
    
    # Global ayarlar
    globalConfig = ''
      # ACME (Let's Encrypt) ayarları
      acme_ca https://acme-v02.api.letsencrypt.org/directory
      
      # Security headers
      servers {
        protocols h1 h2 h3
      }
    '';
    
    virtualHosts = {
      # Ghost Blog
      "blog.deepshell.org" = {
        extraConfig = ''
          # Security headers
          header {
            Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
            X-Content-Type-Options "nosniff"
            X-Frame-Options "SAMEORIGIN"
            Referrer-Policy "strict-origin-when-cross-origin"
          }
          
          reverse_proxy localhost:2368
        '';
      };
      
      # Nextcloud
      "cloud.deepshell.org" = {
        extraConfig = ''
          header {
            Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
          }
          
          # Nextcloud için özel ayarlar
          redir /.well-known/carddav /remote.php/dav 301
          redir /.well-known/caldav /remote.php/dav 301
          
          reverse_proxy localhost:8080 {
            header_up X-Forwarded-For {remote_host}
          }
        '';
      };
      
      # Vaultwarden (Password Manager)
      "vault.deepshell.org" = {
        extraConfig = ''
          header {
            Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
          }
          
          reverse_proxy localhost:8222
          reverse_proxy /notifications/hub localhost:3012
        '';
      };
      
      # Uptime Kuma (Monitoring)
      "status.deepshell.org" = {
        extraConfig = ''
          reverse_proxy localhost:3001
        '';
      };
      
      # Gitea (Git Server)
      "git.deepshell.org" = {
        extraConfig = ''
          reverse_proxy localhost:3000
        '';
      };
      
      # Grafana (Metrics)
      "metrics.deepshell.org" = {
        extraConfig = ''
          reverse_proxy localhost:3002
        '';
      };
      
      # Docker apps için hazır
      "rss.deepshell.org" = {
        extraConfig = ''
          reverse_proxy localhost:8081
        '';
      };
      
      # Ntfy (Notifications)
      "ntfy.deepshell.org" = {
        extraConfig = ''
          reverse_proxy localhost:8083
        '';
      };
      
      # Netdata (System Monitoring - optional)
      "netdata.deepshell.org" = {
        extraConfig = ''
          reverse_proxy localhost:19999
        '';
      };
    };
  };

  # Caddy için automatic certificate renewal
  systemd.services.caddy.serviceConfig = {
    # Restart on failure
    Restart = "on-failure";
    RestartSec = "5s";
  };
}
