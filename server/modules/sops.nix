#######################################
#               SOPS                  #
#######################################
{
  config,
  lib,
  pkgs,
  ...
}: {
  sops.defaultSopsFile = ../../secrets/main2.yaml;
  sops.age.keyFile = "/home/server-pc/secrets/new_age_key.txt";

  sops.secrets."nextcloud_db_passwd" = {
    sopsFile = ../../secrets/main.yaml;
    key = "postgres_password";
  };
}
