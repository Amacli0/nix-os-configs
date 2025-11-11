#######################################
#              OLLAMA                #
#######################################
{
  config,
  lib,
  pkgs,
  ...
}: {
  services = {
    ollama = {
      enable = true;
      loadModels = ["phi3:mini"];
      host = "0.0.0.0";
    };
  };
}
