#######################################
#              SECURITY               #
#######################################
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  security.pki.certificates = [
    (builtins.readFile ./MEB_SERTIFIKASI.pem)
  ];
  networking = {
    firewall = {
      enable = true;
      checkReversePath = true;
      allowedTCPPorts = [
        22
        631
        8888
        9999
        8080
        8754
        30005
      ];
      allowedUDPPorts = [
        3500
        36963
        41641
      ];
      trustedInterfaces = ["tailscale0"];
    };
  };
  services.dump1090-fa = {
    enable = true;
  };

  services.nginx = {
    enable = true;
    virtualHosts."localhost" = {
      locations."/" = {
        root = "${pkgs.dump1090-fa}/share/dump1090-fa/html";
        tryFiles = "$uri $uri/ /index.html";
      };
      locations."/data/" = {
        proxyPass = "http://127.0.0.1:30005/data/";
        proxyWebsockets = true;
      };
    };
  };
  services.udev.packages = [pkgs.rtl-sdr];
}
