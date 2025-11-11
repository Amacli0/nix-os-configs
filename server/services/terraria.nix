{
  config,
  pkgs,
  lib,
  ...
}: {
  services = {
    terraria = {
      dataDir = "/var/lib/terraria";
      enable = true;
      worldPath = "/var/lib/terraria/Hyper_Homeland_of_Inflation.wld";
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
