{pkgs, ...}: {
  home.packages = with pkgs; [
    platformio
    avrdude
    go
    delve
    python3
    vscodium
    esptool
    rtl-sdr
    sdrpp
  ];
}
