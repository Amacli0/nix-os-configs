{
  config,
  pkgs,
  lib,
  ...
}: let
  # Güvenli dosya yolunu alıyoruz (e.g., /run/secrets/nextcloud-db-password)
  dbPasswordPath = config.sops.secrets."nextcloud_db_passwd".path;
in {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
    dive
    podman-tui
    podman
    shadow
  ];
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      candy = {
        image = "docker.io/library/caddy:latest";

        ports = [
          "8080:80"
        ];
        environment = {
          TZ = "Europe/Istanbul"; # Saat dilimi
        };

        autoStart = true;

        volumes = [
          "/var/lib/candy:/data" # Örnek: kalıcı veri
        ];
      };
      n8n = {
        # Resmi n8n image'ı
        image = "docker.io/n8nio/n8n:latest";

        # Web arayüzü için port
        ports = [
          "8082:5678"
        ];

        # Environment variables
        environment = {
          # Timezone ayarı
          TZ = "Europe/Istanbul";
          GENERIC_TIMEZONE = "Europe/Istanbul";

          # n8n temel ayarları
          N8N_HOST = "n8n.deepshell.org";
          N8N_PORT = "5678";
          N8N_PROTOCOL = "https";
          N8N_PROXY_HOPS = "1";

          # Webhook URL (eğer dışarıdan erişilecekse)
          WEBHOOK_URL = "https://n8n.deepshell.org";
        };

        # Kalıcı veri için volume
        volumes = [
          "n8n_data:/home/node/.n8n"
        ];

        autoStart = true;
      };

      # PostgreSQL veritabanı (Nextcloud için)
      nextcloud-db = {
        image = "docker.io/library/postgres:16-alpine";

        environment = {
          POSTGRES_DB = "nextcloud";
          POSTGRES_USER = "nextcloud";
          POSTGRES_PASSWORD = nextcloudDBPassword; # Bunu değiştir!
        };

        volumes = [
          "nextcloud_db:/var/lib/postgresql/data"
        ];

        autoStart = true;
      };

      # Nextcloud
      nextcloud = {
        image = "docker.io/library/nextcloud:latest";

        ports = [
          "8081:80" # Nextcloud -> 8081
        ];

        environment = {
          # PostgreSQL bağlantı bilgileri
          POSTGRES_HOST = "nextcloud-db";
          POSTGRES_DB = "nextcloud";
          POSTGRES_USER = "nextcloud";
          POSTGRES_PASSWORD = nextcloudDBPassword; # Yukarıdakiyle aynı olmalı!

          # Nextcloud ayarları
          NEXTCLOUD_ADMIN_USER = "admin";
          NEXTCLOUD_ADMIN_PASSWORD = ""; # Bunu değiştir!
          NEXTCLOUD_TRUSTED_DOMAINS = "localhost 100.108.192.97 100.116.167.72 100.117.164.25"; # IP'ni ekle
        };

        volumes = [
          "nextcloud_data:/var/www/html"
        ];

        autoStart = true;
      };
    };
  };
}
