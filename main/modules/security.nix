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
    (builtins.readFile ../MEB_SERTIFIKASI.pem)
  ];
  networking = {
    firewall = {
      enable = true;
      checkReversePath = true;
      allowedTCPPorts = [22];
      allowedUDPPorts = [53 41641];
      trustedInterfaces = ["tailscale0"];
    };
  };
}
