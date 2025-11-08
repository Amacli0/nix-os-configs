{
  config,
  lib,
  pkgs,
  ...
}: {
  #######################################
  #              IMPORTS              #
  #######################################
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ./services/podman.nix
  ];
  #######################################
  #              BOOT AYARLARI          #
  #######################################
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };

    loader = {
      systemd-boot.enable = true;

      timeout = 15;
    };
  };
  #######################################
  #           SOPS AYARLARI             #
  #######################################

  sops.defaultSopsFile = ../secrets/main2.yaml;
  sops.age.keyFile = "/home/server-pc/secrets/new_age_key.txt";
  sops.secrets = {
    sopsFile = ../secrets/main.yaml;
    key = "POSTGRES_PASSWORD";
  };
  #######################################
  #              NETWORK                #
  #######################################
  networking = {
    #HOSTNAME
    hostName = "server-pc";
    #FİREWALL
    firewall = {
      enable = true;
      allowedTCPPorts = [22 80 443 5678 8080 8082 11434];
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = [41641];
    };
  };
  #######################################
  #              KULLANICI              #
  #######################################
  users.users.server-pc = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "tailscale" "podman" "docker"];
  };
  #######################################
  #              SERVİSLER              #
  #######################################
  services = {
    openssh = {
      enable = true;
    };

    tailscale = {
      enable = true;
    };
    ollama = {
      enable = true;
      loadModels = ["phi3:mini"];
      host = "0.0.0.0";
    };
  };
  #######################################
  #            SİSTEM VERSİON           #
  #######################################
  system.stateVersion = "25.05";
}
