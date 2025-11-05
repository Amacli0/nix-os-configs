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
  autoPrune = {
    enable = true;
    dates = "weekly";
  };
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      candy = {
        image = "ghcr.io/cultureamp/docker-candy:latest";

        ports = [
          "8080:8080"
        ];
        environment = {
          TZ = "Europe/Istanbul"; # Saat dilimi
        };

        autoStart = true;

        volumes = [
          # "/var/lib/candy:/data"  # Örnek: kalıcı veri
        ];
      };
    };
  };
}
