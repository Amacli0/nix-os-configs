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
      brlaser # Açık kaynak Brother sürücüsü (HL-20'ye destek verme olasılığı var)
    ];
  };
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
}
