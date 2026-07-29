{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Sops ana yapılandırması
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;

    # Klonlayan kişinin veya sistemin age anahtar konumu
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    # Gizli anahtarların tanımları
    secrets = {
      searx_secret_key = {};
      # İleride eklenecek gizli bilgiler buraya alt alta yazılacak:
      # wifi_password = {};
      # hashed_user_password = {};
    };
  };
}
