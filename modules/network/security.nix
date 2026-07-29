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
  security.pki.certificates =
    if (builtins.pathExists ./MEB_SERTIFIKASI.pem)
    then [
      (builtins.readFile ./MEB_SERTIFIKASI.pem)
    ]
    else [];
  networking = {
    firewall = {
      enable = true;
      checkReversePath = "loose";
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
        53
        67
        3500
        36963
        41641
      ];
      trustedInterfaces = [
        "tailscale0"
      ];
    };
  };
}
