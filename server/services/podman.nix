{
  config,
  pkgs,
  ...
}: {
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
          N8N_HOST = "0.0.0.0";
          N8N_PORT = "5678";
          N8N_PROTOCOL = "http";

          # Webhook URL (eğer dışarıdan erişilecekse)
          # WEBHOOK_URL = "https://n8n.yourdomain.com";
        };

        # Kalıcı veri için volume
        volumes = [
          "n8n_data:/home/node/.n8n"
        ];

        autoStart = true;
      };
    };
  };
}
