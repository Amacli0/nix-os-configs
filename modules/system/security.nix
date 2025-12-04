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
      checkReversePath = false;
      allowedTCPPorts = [
        22
        631
        9999
      ];
      allowedUDPPorts = [
        53
        36963
        41641
      ];
      trustedInterfaces = ["tailscale0"];
    };
  };

  security.polkit.enable = true;
}
