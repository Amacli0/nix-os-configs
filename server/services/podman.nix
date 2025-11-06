{
  config,
  pkgs,
  lib,
  ...
}: let
  # SOPS'un oluşturduğu güvenli dosya yolu
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
  };

  containers = {
    candy = {
      image = "docker.io/library/caddy:latest";
      ports = ["8080:80"];
      environment = {TZ = "Europe/Istanbul";};
      volumes = ["/var/lib/candy:/data"];
      autoStart = true;
    };

    n8n = {
      image = "docker.io/n8nio/n8n:latest";
      ports = ["8082:5678"];
      environment = {
        TZ = "Europe/Istanbul";
        GENERIC_TIMEZONE = "Europe/Istanbul";
        N8N_HOST = "n8n.deepshell.org";
        N8N_PORT = "5678";
        N8N_PROTOCOL = "https";
        N8N_PROXY_HOPS = "1";
        WEBHOOK_URL = "https://n8n.deepshell.org";
      };
      volumes = ["n8n_data:/home/node/.n8n"];
      autoStart = true;
    };

    nextcloud-db = {
      image = "docker.io/library/postgres:16-alpine";
      environment = {
        POSTGRES_DB = "nextcloud";
        POSTGRES_USER = "nextcloud";
        POSTGRES_PASSWORD_FILE = dbPasswordPath;
      };
      volumes = [
        "/var/lib/nextcloud-db:/var/lib/postgresql/data"
        "${dbPasswordPath}:${dbPasswordPath}:ro"
      ];
      networks = ["nextcloud-net"];
      autoStart = true;
    };

    nextcloud = {
      image = "docker.io/library/nextcloud:latest";
      ports = ["8081:80"];
      environment = {
        POSTGRES_HOST = "nextcloud-db";
        POSTGRES_DB = "nextcloud";
        POSTGRES_USER = "nextcloud";
        POSTGRES_PASSWORD_FILE = dbPasswordPath;

        NEXTCLOUD_ADMIN_USER = "admin";
        NEXTCLOUD_ADMIN_PASSWORD = "admin"; # test için
        NEXTCLOUD_TRUSTED_DOMAINS = "localhost 100.108.192.97 100.116.167.72 100.117.164.25";
      };
      volumes = ["nextcloud_data:/var/www/html"];
      networks = ["nextcloud-net"];
      autoStart = true;
    };
  };
}
