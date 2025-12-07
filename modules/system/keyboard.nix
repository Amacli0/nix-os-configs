######################
#     KEYBOARD       #
######################
{
  config,
  pkgs,
  ...
}: {
  time.timeZone = "Europe/Istanbul";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    keyMap = "trq";
    font = "Lat2-Terminus16";
  };
}
