{
  config,
  pkgs,
  lib,
  ...
}: {
  services = {
    terraria-main = {
      dataDir = "/var/lib/terraria";
      enable = true;
      worldPath = "/var/lib/terraria";
      secure = true;
      port = 7777;
      password = null;
      openFirewall = true;
      noUPnP = true;
      messageOfTheDay = "HERKESE MERHABALAR. NİXOS İLE  KURULMUŞ BİR TERRARİA SERVERDASINIZ. İYİ OYUNLAR";
      maxPlayers = 5;
      banListPath = null;
    };
  };
}
