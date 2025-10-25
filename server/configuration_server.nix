{ config, lib, pkgs, ... }:
{
  imports = [ 
    ./hardware-configuration.nix
    ./services/core.nix       # PostgreSQL, Caddy
    ./services/web-apps.nix   # Nextcloud, Vaultwarden, Gitea
    ./services/docker.nix     # Docker + compose setup
    ./services/ddns.nix       # Cloudflare DDNS
    # ./services/monitoring.nix # Opsiyonel: Grafana, Prometheus vs
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.tmp.cleanOnBoot = true;
  
  # Network
  networking.hostName = "server-pc";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 
      22    # SSH
      80    # HTTP
      443   # HTTPS
    ];
    allowedUDPPorts = [ 
      41641 # Tailscale
    ];
    trustedInterfaces = [ "tailscale0" ];
  };

  # Locale & Time
  time.timeZone = "Europe/Istanbul";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "trq";
    font = "latarcyrheb-sun32";
  };

  # Nix Settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      max-jobs = 4;
    };
    
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    # Temel
    git
    neovim
    nano
    terminus_font
    
    # Monitoring & Debug
    btop
    iotop
    ncdu
    
    # Network
    curl
    wget
    dig
    netcat
    
    # SOPS
    age
    sops
    
    # Docker
    docker-compose
    
    # PostgreSQL client
    postgresql
  ];

  # Editor
  environment.variables.EDITOR = "neovim";
  
  # Shell aliases
  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-flake-config#server-pc";
    update = "cd ~/nixos-flake-config && nix flake update && sudo nixos-rebuild switch --flake .#server-pc";
    logs = "journalctl -xeu";
    dsize = "ncdu /";
    dstatus = "systemctl status docker-*";
  };

  # User Configuration
  users.users.server-pc = {
    isNormalUser = true;
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "tailscale"
      "docker"
    ];
    shell = pkgs.bash;
  };

  # Security
  security.sudo = {
    enable = true;
    extraRules = [{
      groups = [ "wheel" ];
      commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }];
    }];
  };

  # SOPS Configuration
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age.keyFile = "/root/.config/sops/age/keys.txt";
    
    secrets = {
      # Nextcloud
      nextcloud-admin-password = { 
        owner = "nextcloud"; 
      };
      
      # Vaultwarden (environment file formatında)
      vaultwarden-admin-token = { 
        owner = "vaultwarden";
        mode = "0400";
      };
      
      # Cloudflare DDNS
      cloudflare-ddns-env = {
        owner = "root";
        mode = "0400";
      };
      cloudflare-api-token = { 
        owner = "root";
        mode = "0400";
      };
      
      # Docker apps (opsiyonel - şimdilik gerek yok)
      # freshrss-admin-password = {};
      # gitea-admin-password = {};
    };
  };

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
      X11Forwarding = false;
    };
  };

  # Tailscale
  services.tailscale.enable = true;

  # Journal size limit
  services.journald.extraConfig = ''
    SystemMaxUse=500M
    MaxRetentionSec=7day
  '';

  # Auto upgrade (şimdilik kapalı)
  system.autoUpgrade.enable = false;

  system.stateVersion = "25.05";
}
