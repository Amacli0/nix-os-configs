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
        30001
        30002
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
        proxyPass = "http://127.0.0.1:8080/"; # dump1090's built-in server
      };
    };
  };
  services.udev.packages = [pkgs.rtl-sdr];
}
