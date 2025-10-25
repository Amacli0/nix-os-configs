{ config, lib, pkgs, ... }:
{
  imports = [ 
    ./hardware-configuration.nix
       ./services/core.nix       # PostgreSQL, Caddy
       ./services/web-apps.nix   # Ghost, Nextcloud
       ./services/monitoring.nix # Uptime Kuma, Netdata
       ./services/docker.nix# Docker + compose setup
       ./services/ddns.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # Disk optimizasyonu (240GB için önemli)
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
      max-jobs = 4; # i5-6500T için
    };
    
    # Otomatik garbage collection (disk tasarrufu)
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
    ncdu  # Disk kullanım analizi
    
    # Network
    curl
    wget
    dig
    netcat
    
    # SOPS
    age
    sops
    
    # Docker (compose için)
    docker-compose
    
    # PostgreSQL client
    postgresql
  ];

  # Editor
  environment.variables.EDITOR = "neovim";
  
  # Shell aliases (opsiyonel)
  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake .#server-pc";
    update = "nix flake update && sudo nixos-rebuild switch --flake .#server-pc";
    logs = "journalctl -xeu";
    dsize = "ncdu /";
  };

  # User Configuration
  users.users.server-pc = {
    isNormalUser = true;
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "tailscale"
      "docker"  # Docker için
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
      # Database
      postgres-ghost-password = { owner = "ghost"; };
      postgres-nextcloud-password = { owner = "nextcloud"; };
      
      # Applications
      ghost-admin-password = { owner = "ghost"; };
      nextcloud-admin-password = { owner = "nextcloud"; };
      vaultwarden-admin-token = { owner = "vaultwarden"; };
      
      # Monitoring
      uptime-kuma-admin-password = {};
      
      # Docker apps
      freshrss-admin-password = {};
      gitea-admin-password = {};
      
      # Cloudflare (opsiyonel)
      cloudflare-api-token = { owner = "caddy"; };
    };
  };

  # Basic Services
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
      X11Forwarding = false;
    };
  };

  services.tailscale.enable = true;

  # Systemd journal size limit (disk tasarrufu)
  services.journald.extraConfig = ''
    SystemMaxUse=500M
    MaxRetentionSec=7day
  '';

  # Otomatik güvenlik güncellemeleri
  system.autoUpgrade = {
    enable = false;  # Manuel kontrol edelim başta
    # enable = true;
    # flake = "github:yourusername/nixos-flake-config";
    # flags = [ "--update-input" "nixpkgs" ];
  };

  system.stateVersion = "25.05";
}
