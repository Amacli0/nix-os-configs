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
  services.udev.extraRules = ''
    # Laptop dahili klavyesini (AT Translated Set 2) devre dışı bırak
    ACTION=="add|change", KERNEL=="event0", SUBSYSTEM=="input", ATTRS{name}=="AT Translated Set 2 keyboard", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';
}
