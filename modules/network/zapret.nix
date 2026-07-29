{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  zapret = {
    enable = true;
    params = [
      "--dpi-desync=fake"
      "--dpi-desync-repeats=6"
      "--dpi-desync-fooling=md5sig"
      # TTL değerini siliyoruz, otomatik hesaplaması için:
      "--dpi-desync-autottl=2" # Başlangıçta 2 hop dener, DPI bulana kadar artırır
      "--dpi-desync-any-protocol"
      "--dpi-desync-cutoff=d4"
    ];
  };
}
