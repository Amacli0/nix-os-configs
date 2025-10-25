{ config, lib, pkgs, ... }:
{
  # Ghost Blog Platform
  services.ghost = {
    enable = true;
    
    config = {
      url = "https://blog.deepshell.org";
      
      server = {
        host = "127.0.0.1";
        port = 2368;
      };
      
      # PostgreSQL database
      database = {
        client = "postgres";
        connection = {
          host = "/run/postgresql";
          user = "ghost";
          database = "ghost";
        };
      };
      
      # Mail configuration (opsiyonel - sonra ekle)
      # mail = {
      #   transport = "SMTP";
      #   options = {
      #     service = "Gmail";
      #     host = "smtp.gmail.com";
      #     port = 587;
      #     secure = false;
      #     auth = {
      #       user = "your-email@gmail.com";
      #       pass = "app-specific-password";
      #     };
      #   };
      # };
      
      # Privacy & performance
      privacy = {
        useUpdateCheck = false;
        useGravatar = false;
      };
    };
  };

  # Nextcloud
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    hostName = "cloud.deepshell.org";
    
    config = {
      adminuser = "admin";
      adminpassFile = config.sops.secrets.nextcloud-admin-password.path;
      
      # PostgreSQL
      dbtype = "pgsql";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
    };
    
    settings = {
      trusted_domains = [ "cloud.deepshell.org" ];
      overwriteprotocol = "https";
      default_phone_region = "TR";
      
      # Performance
      "memcache.local" = "\\OC\\Memcache\\APCu";
      "memcache.distributed" = "\\OC\\Memcache\\Redis";
      "memcache.locking" = "\\OC\\Memcache\\Redis";
      redis = {
        host = "/run/redis-nextcloud/redis.sock";
        port = 0;
      };
      
      # Maintenance
      maintenance_window_start = 3; # 03:00'da maintenance
    };
    
    # Upload limits
    maxUploadSize = "16G";
    https = true;
    
    # Apps (opsiyonel - ihtiyacına göre ekle)
    extraAppsEnable = true;
    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit calendar contacts mail notes tasks deck;
    };
  };

  # Redis for Nextcloud
  services.redis.servers.nextcloud = {
    enable = true;
    port = 0;
    unixSocket = "/run/redis-nextcloud/redis.sock";
    unixSocketPerm = 770;
    user = "nextcloud";
  };

  # Vaultwarden (Bitwarden Password Manager)
  services.vaultwarden = {
    enable = true;
    
    config = {
      DOMAIN = "https://vault.deepshell.org";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      
      # WebSocket için
      WEBSOCKET_ENABLED = true;
      WEBSOCKET_ADDRESS = "127.0.0.1";
      WEBSOCKET_PORT = 3012;
      
      # Security
      SIGNUPS_ALLOWED = false;  # Sadece invite ile kayıt
      INVITATIONS_ALLOWED = true;
      
      # Admin panel
      # ADMIN_TOKEN sops'tan gelecek
      
      # Email (opsiyonel)
      # SMTP_HOST = "smtp.gmail.com";
      # SMTP_FROM = "your-email@gmail.com";
      # SMTP_PORT = 587;
      # SMTP_SECURITY = "starttls";
      # SMTP_USERNAME = "your-email@gmail.com";
      # SMTP_PASSWORD = "app-password";
    };
    
    backupDir = "/var/backup/vaultwarden";
  };

  # Gitea (Git Server)
  services.gitea = {
    enable = true;
    
    settings = {
      server = {
        DOMAIN = "git.deepshell.org";
        ROOT_URL = "https://git.deepshell.org";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;
      };
      
      database = {
        DB_TYPE = "postgres";
        HOST = "/run/postgresql";
        NAME = "gitea";
        USER = "gitea";
      };
      
      service = {
        DISABLE_REGISTRATION = true;  # Sadece admin user oluşturabilir
        REQUIRE_SIGNIN_VIEW = false;  # Public repos görülebilir
      };
      
      session = {
        COOKIE_SECURE = true;
      };
      
      # Git LFS support
      lfs = {
        ENABLE = true;
      };
      
      # Mailer (opsiyonel)
      # mailer = {
      #   ENABLED = true;
      #   FROM = "gitea@deepshell.org";
      #   PROTOCOL = "smtp";
      #   SMTP_ADDR = "smtp.gmail.com";
      #   SMTP_PORT = 587;
      # };
    };
    
    database = {
      type = "postgres";
      host = "/run/postgresql";
      name = "gitea";
      user = "gitea";
    };
  };

  # Systemd timers for backups (opsiyonel)
  systemd.timers.backup-databases = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services.backup-databases = {
    script = ''
      ${pkgs.postgresql}/bin/pg_dumpall > /var/backup/postgresql/dump-$(date +%Y%m%d).sql
      
      # 7 günden eski backupları sil
      find /var/backup/postgresql -name "dump-*.sql" -mtime +7 -delete
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "postgres";
    };
  };

  # Backup dizini
  systemd.tmpfiles.rules = [
    "d /var/backup 0755 root root -"
    "d /var/backup/postgresql 0755 postgres postgres -"
    "d /var/backup/vaultwarden 0755 vaultwarden vaultwarden -"
  ];
}
