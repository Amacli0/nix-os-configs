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
  networking = {
    hostName = "server-pc";

    firewall = {
      enable = true;
      checkReversePath = true;
      allowedTCPPorts = [22 80 443];
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = [41641];
    };
  };
  services.fail2ban.enable = true;
}
