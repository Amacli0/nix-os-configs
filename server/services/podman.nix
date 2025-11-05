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
    };
  };
}
