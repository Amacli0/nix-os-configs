{ config, lib, pkgs, ... }:
{
  # ============================================
  # DOCKER - Konteyner servisleri için
  # ============================================
  virtualisation.docker = {
    enable = true;
    # Otomatik başlat
    enableOnBoot = true;
    # Eski image'ları otomatik temizle
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Docker için ek ayarlar
  virtualisation.oci-containers.backend = "docker";  # Podman yerine Docker kullan

  # ============================================
  # POSTGRESQL - Veritabanı
  # ============================================
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;  # PostgreSQL 16 kullan
    
    # Otomatik başlat
    enableTCPIP = true;  # Ağ bağlantılarını aktif et
    
    # Port ayarı (varsayılan 5432)
    port = 5432;
    
    # İlk kurulumda veritabanlarını oluştur
    ensureDatabases = [ 
      "nextcloud"   # Nextcloud için
      "ghost"       # Ghost için
    ];
    
    # Kullanıcıları oluştur
    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;  # nextcloud DB'sine tam yetki
      }
      {
        name = "ghost";
        ensureDBOwnership = true;  # ghost DB'sine tam yetki
      }
    ];
    
    # Güvenlik ayarları
    authentication = pkgs.lib.mkOverride 10 ''
      # Local bağlantılar için trust (güvenli, sadece sunucu içi)
      local   all             all                                     trust
      # Localhost için trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust
      # Docker network'ü için (sonra güncelleyeceğiz)
      host    all             all             172.17.0.0/16           md5
    '';
  };

  # PostgreSQL otomatik yedekleme
  services.postgresqlBackup = {
    enable = true;
    location = "/var/backup/postgresql";  # Yedek konumu
    startAt = "*-*-* 03:00:00";  # Her gün saat 03:00'da yedekle
  };

  # ============================================
  # FAIL2BAN - Brute force koruması
  # ============================================
  services.fail2ban = {
    enable = true;
    maxretry = 5;  # 5 başarısız denemeden sonra banla
    ignoreIP = [
      "127.0.0.1/8"    # Localhost
      "10.0.0.0/8"     # Özel ağlar
      "172.16.0.0/12"  # Docker network
      # Tailscale IP'lerini buraya ekleyeceğiz
    ];
    
    # SSH koruması
    jails.sshd = ''
      enabled = true
      port = 22
      filter = sshd
      logpath = /var/log/auth.log
      maxretry = 3
      bantime = 3600
    '';
  };

  # ============================================
  # NGINX - Reverse Proxy
  # ============================================
  services.nginx = {
    enable = true;
    
    # Önerilen ayarlar
    recommendedGzipSettings = true;   # Sıkıştırma
    recommendedOptimisation = true;   # Optimizasyon
    recommendedProxySettings = true;  # Proxy ayarları
    recommendedTlsSettings = true;    # SSL/TLS ayarları
    
    # Maksimum upload boyutu (Nextcloud için önemli)
    clientMaxBodySize = "512M";
  };

  # ============================================
  # ACME (Let's Encrypt) - SSL Sertifikaları
  # ============================================
  security.acme = {
    acceptTerms = true;
    defaults.email = "deepshell@proton.me";  # BURAYA KENDİ EMAİLİNİ YAZ!
  };
}
