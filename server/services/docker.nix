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

  systemd.services."nginx-container" = {
    description = "Test nginx container";
    wantedBy = ["default.target"];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.podman}/bin/podman run --name nginx-test \
        -p 8080:80 \
        docker.io/library/nginx:latest
      '';

      ExecStop = "${pkgs.podman}/bin/podman stop nginx-test";
      Restart = "always";
    };
  };
}
