#######################################
#            PAKETLER                 #
#######################################
{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    cloudflared
  ];
}
