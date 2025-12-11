################################
#          PRINTER             #
################################
{
  config,
  pkgs,
  ...
}: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      brlaser
    ];
  };
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
}
