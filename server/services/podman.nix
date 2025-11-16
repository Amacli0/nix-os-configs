{
  config,
  pkgs,
  lib,
  ...
}: let
  # SOPS'un oluşturduğu güvenli dosya yolu
  dbPasswordPath = config.sops.secrets."nextcloud_db_passwd".path;
  matrixPasswordPath = config.sops.secrets."matrix_db_passwd".path;
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
  #OCI KONTEYNERLAR
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      #CANDY
      candy = {
        image = "docker.io/library/caddy:latest";
        ports = ["8080:80"];
        environment = {
          TZ = "Europe/Istanbul";
        };
        volumes = ["/var/lib/candy:/data"];
        autoStart = true;
      };
      #N8N
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
        extraOptions = [
          "--cap-add=NET_RAW"
          "--cap-add=NET_ADMIN"
        ];
      };
      #NEXTCLOUD DB
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
        extraOptions = ["--network=nextcloud-net"];
        autoStart = true;
      };
      #NEXTCLOUD
      nextcloud = {
        image = "docker.io/library/nextcloud:latest";
        ports = ["8081:80"];
        environment = {
          POSTGRES_HOST = "nextcloud-db";
          POSTGRES_DB = "nextcloud";
          POSTGRES_USER = "nextcloud";
          POSTGRES_PASSWORD_FILE = dbPasswordPath;
          NEXTCLOUD_ADMIN_USER = "admin";
          NEXTCLOUD_ADMIN_PASSWORD = "admin";
          NEXTCLOUD_TRUSTED_DOMAINS = "localhost 100.108.192.97 100.116.167.72 100.117.164.25 ";
        };
        volumes = [
          "nextcloud_data:/var/www/html"
          "${dbPasswordPath}:${dbPasswordPath}:ro"
        ];
        extraOptions = ["--network=nextcloud-net"];
        dependsOn = ["nextcloud-db"];
        autoStart = true;
      };
      #fresh rss
      fresh-rss = { 
        image = "freshrss/freshrss:latest";
        ports = ["8083:80"];
        environment = {
          TZ   = "Europe/Istanbul";

          DB_TYPE = "mysql"; 
          DB_HOST = "freshrss-db"; 
          DB_NAME = "freshrssdb";
          DB_USER = "freshrss_user";
          DB_PASS_FILE = dbPasswordPath;

        };
        volumes = [
          "/var/lib/fresh-rss:/var/www/FreshRSS/data"
          "${dbPasswordPath}:${dbPasswordPath}:ro"
        ];
        extraOptions = ["--network=freshrss-net"];
        dependsOn = ["freshrss-db"];
        autoStart = true;
      };
      #fresh rss data base
      freshrss-db = {
        image = "docker.io/library/mariadb:latest";
        environment = {
          MARIADB_DATABASE = "freshrssdb";
          MARIADB_USER = "freshrss_user";
          MARIADB_PASSWORD_FILE = dbPasswordPath; # Aynı şifre dosyasını kullanabiliriz
        };
        volumes = [
          "/var/lib/freshrss-db:/var/lib/mysql"
          "${dbPasswordPath}:${dbPasswordPath}:ro"
        ];
        extraOptions = ["--network=freshrss-net"]; # Yeni bir ağ oluşturmak daha temizdir
        autoStart = true;
      };

      #JELLYFIN
      jellyfin = {
        image = "docker.io/jellyfin/jellyfin:latest";
        ports = [
          "8096:8096"
          "8920:8920"
          "7359:7359/udp"
          "1900:1900/udp"
        ];
        environment = {
          TZ = "Europe/Istanbul";
          JELLYFIN_PublishedServerUrl = "http://localhost:8096";
        };
        volumes = [
          "/var/lib/jellyfin/config:/config"
          "/var/lib/jellyfin/cache:/cache"
          "/media/movies:/media/movies:ro"
          "/media/tv:/media/tv:ro"
          "/media/music:/media/music:ro"
        ];
        extraOptions = [
          "--device=/dev/dri:/dev/dri"
        ];
        autoStart = true;
      };
  #IMMICH DATABASE
      immich-db = {
        image = "docker.io/tensorchord/pgvecto-rs:pg14-v0.2.0";
        environment = {
          POSTGRES_DB = "immich";
          POSTGRES_USER = "immich";
          POSTGRES_PASSWORD_FILE =  dbPasswordPath;
        };
        volumes = [
          "/var/lib/immich-db:/var/lib/postgresql/data"
          "${dbPasswordPath}:${dbPasswordPath}:ro"
        ];
        extraOptions = ["--network=immich-net"];
        autoStart = true;
      };

 #IMMICH REDIS
      immich-redis = {
        image = "docker.io/library/redis:7-alpine";
        extraOptions = ["--network=immich-net"];
        autoStart = true;
      };


      #IMMICH SERVER
      immich-server = {
        image = "ghcr.io/immich-app/immich-server:release";
        ports = ["2283:3001"];
        environment = {
          TZ = "Europe/Istanbul";
          DB_HOSTNAME = "immich-db";
          DB_USERNAME = "immich";
          DB_PASSWORD_FILE =  dbPasswordPath;
          DB_DATABASE_NAME = "immich";
          REDIS_HOSTNAME = "immich-redis";
          UPLOAD_LOCATION = "/usr/src/app/upload";
        };
        volumes = [
          "/var/lib/immich/upload:/usr/src/app/upload"
          "${dbPasswordPath}:${dbPasswordPath}:ro"
        ];
        extraOptions = ["--network=immich-net"];
        dependsOn = ["immich-db" "immich-redis"];
        autoStart = true;
      };
      #IMMICH MACHINE LEARNING
      immich-ml = {
        image = "ghcr.io/immich-app/immich-machine-learning:release";
        environment = {
          TZ = "Europe/Istanbul";
        };
        volumes = [
          "/var/lib/immich/model-cache:/cache"
        ];
        extraOptions = ["--network=immich-net"];
        autoStart = true;
      };

    };
  };
}
