{ config, lib, pkgs, ... }:
{
  # ============================================
  # DOCKER
  # ============================================
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  virtualisation.oci-containers.backend = "docker";

  # ============================================
  # POSTGRESQL
  # ============================================
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = true;
    port = 5432;
    
    ensureDatabases = [ 
      "nextcloud"
      "ghost"
    ];
    
    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
      {
        name = "ghost";
        ensureDBOwnership = true;
      }
    ];
    
    authentication = pkgs.lib.mkOverride 10 ''
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust
      host    all             all             172.17.0.0/16           md5
    '';
  };

  services.postgresqlBackup = {
    enable = true;
    location = "/var/backup/postgresql";
    startAt = "*-*-* 03:00:00";
  };

  # ============================================
  # FAIL2BAN - YENİ FORMAT
  # ============================================
  services.fail2ban = {
    enable = true;
    
    # Global ayarlar
    maxretry = 5;  # Varsayılan deneme sayısı
    bantime = "1h";  # Ban süresi (1 saat)
    
    # Güvenilir IP'ler (banlanmayacak)
    ignoreIP = [
      "127.0.0.1/8"    # Localhost
      "10.0.0.0/8"     # Özel ağ
      "172.16.0.0/12"  # Docker network
      "192.168.0.0/16" # Yerel ağ
    ];
    
    # SSH jail'i - yeni submodule formatı
    jails = {
      sshd = {
        # SSH koruma jail'ini aktif et
        settings = {
          enabled = true;
          port = "22";
          filter = "sshd";
          logpath = "/var/log/auth.log";
          maxretry = 3;  # SSH için daha sıkı: 3 yanlış deneme
          bantime = "3600";  # 1 saat ban
        };
      };
      
      # Nginx için de jail ekleyelim
      nginx-http-auth = {
        settings = {
          enabled = true;
          port = "80,443";
          filter = "nginx-http-auth";
          logpath = "/var/log/nginx/error.log";
          maxretry = 5;
        };
      };
    };
  };

  # ============================================
  # NGINX
  # ============================================
  services.nginx = {
    enable = true;
    
    # Önerilen ayarlar
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    
    # Upload limiti (Nextcloud için)
    clientMaxBodySize = "512M";
    
    # Log dosyaları (fail2ban için gerekli)
    appendHttpConfig = ''
      # Rate limiting için zone tanımla
      limit_req_zone $binary_remote_addr zone=loginlimit:10m rate=5r/m;
      
      # Nginx log format
      log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    '';
  };

  # ============================================
  # ACME (Let's Encrypt)
  # ============================================
  security.acme = {
    acceptTerms = true;
    defaults.email = "senin@email.com";  # BURAYA EMAİLİNİ YAZ!
    
    # Staging mode - test için (sonra kapatacağız)
    # defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";
  };
  
  # Nginx'in ACME challenge'ları okuyabilmesi için
  users.users.nginx.extraGroups = [ "acme" ];
}
