{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./services/core.nix           # Temel servisler
    ./services/networking.nix     # Ağ servisleri
    ./services/web-apps.nix       # Web uygulamaları
    ./services/monitoring.nix     # İzleme araçları
  ];

  # ============================================
  # BOOT AYARLARI
  # ============================================
  boot.loader.systemd-boot.enable = true;  # Systemd boot kullan
  boot.loader.efi.canTouchEfiVariables = true;  # EFI değişkenlerine yazabilir
  boot.kernelPackages = pkgs.linuxPackages_latest;  # En son kernel

  # ============================================
  # AĞ AYARLARI
  # ============================================
  networking.hostName = "server-pc";
  networking.networkmanager.enable = true;
  
  # Firewall - Sadece gerekli portları aç
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 
      22    # SSH
      80    # HTTP
      443   # HTTPS
      8080  # Alternatif HTTP (bazı servisler için)
      9443  # Portainer
    ];
    allowedUDPPorts = [ 
      41641  # Tailscale
      51820  # WireGuard
    ];
    # Tailscale interface'ini güvenilir olarak işaretle
    trustedInterfaces = [ "tailscale0" ];
  };

  # ============================================
  # ZAMAN VE DİL
  # ============================================
  time.timeZone = "Europe/Istanbul";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "trq";   
    font = "latarcyrheb-sun32";
  };

  # ============================================
  # NIX AYARLARI
  # ============================================
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    # Otomatik garbage collection - disk dolmasını önler
    auto-optimise-store = true;
  };
  
  # Haftada bir eski paketleri temizle
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # ============================================
  # SOPS - Şifreleme için
  # ============================================
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;  # Şifreli dosyanın yeri
    age.keyFile = "/var/lib/sops-nix/key.txt";  # Şifre çözme anahtarı
    
    # Burada hangi secret'ları kullanacağını tanımlayacağız
    # Şimdilik boş bırakıyoruz, servisleri eklerken dolduracağız
    secrets = {};
  };

  # ============================================
  # SİSTEM PAKETLERİ
  # ============================================
  environment.systemPackages = with pkgs; [
    git
    neovim
    btop           # Daha güzel sistem monitör
    ncdu           # Disk kullanımı analizi
    wget
    curl
    unzip
    docker-compose
    age            # sops için şifreleme
    sops           # Secret yönetimi
    terminus_font
  ];

  # ============================================
  # KULLANICI AYARLARI
  # ============================================
  users.users.server-pc = {
    isNormalUser = true;
    extraGroups = [
      "wheel"          # sudo yetkisi için
      "networkmanager" # Ağ ayarlarını değiştirebilmek için
      "docker"         # Docker kullanabilmek için
      "tailscale"      # Tailscale yönetimi için
    ];
    # İlk kurulumda şifre belirlemelisin: passwd server-pc
  };

  # Sudo ayarları
  security.sudo = {
    enable = true;
    extraRules = [{
      groups = [ "wheel" ];
      commands = [{ 
        command = "ALL";
        options = [ "NOPASSWD" ];  # Şifresiz sudo (opsiyonel, güvenlik riski!)
      }];
    }];
  };

  # ============================================
  # SSH
  # ============================================
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";  # Root ile giriş yasak (güvenlik)
      PasswordAuthentication = true;  # Şifre ile giriş (sonra key-based'e geçebilirsin)
    };
  };

  # NixOS sürümü - DEĞİŞTİRME!
  system.stateVersion = "25.05";
}
