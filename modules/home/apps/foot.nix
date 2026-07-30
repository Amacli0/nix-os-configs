########################
#         FOOT         #
########################
{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        # Fallback olarak JetBrains Mono ekleyerek DejaVu uyarısını engelliyoruz
        font = lib.mkForce "Fixedsys Excelsior:size=12, JetBrains Mono:size=11";
        pad = "8x8";
      };
      # [colors] yerine [colors-dark] kullanıyoruz
      tweak = {
        font-monospace-warn = "no"; # Monospace uyarısını tamamen sessize al
      };
    };
  };
}
