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
    keyMap = "us";
    font = "Lat2-Terminus16";
  };

  services.udev.extraRules = ''
    # Laptop klavyesini veya dahili klavyeyi libinput için yoksayma kuralı
    ACTION=="add|change", KERNEL=="event0", SUBSYSTEM=="input", ATTRS{name}=="AT Translated Set 2 keyboard", ENV{LIBINPUT_IGNORE_DEVICE}="1"

    # Epomaker / VIA / QMK klavyeler için web tarayıcı erişim kuralı
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", TAG+="udev-acl"
  '';
}
