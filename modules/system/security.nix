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
}
