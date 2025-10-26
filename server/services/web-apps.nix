{ config, lib, pkgs, ... }:
{
  # ============================================
  # PORTAINER - Docker Yönetim Arayüzü
  # ============================================
  # Portainer ile diğer servisleri daha kolay yönetebiliriz
  
  virtualisation.oci-containers.containers.portainer = {
    image = "portainer/portainer-ce:latest";
    
    # Otomatik başlat
    autoStart = true;
    
    # Port mapping
    ports = [
      "9443:9443"  # HTTPS arayüzü
      "8000:8000"  # Edge agent (opsiyonel)
    ];
    
    # Volume mount - Portainer verilerini sakla
    volumes = [
      "portainer_data:/data"                    # Portainer verileri
      "/var/run/docker.sock:/var/run/docker.sock:ro"  # Docker socket (read-only)
    ];
    
    # Restart policy
    extraOptions = [
      "--restart=always"
    ];
  };

  # ============================================
  # UPTIME KUMA - Servis İzleme
  # ============================================
  virtualisation.oci-containers.containers.uptime-kuma = {
    image = "louislam/uptime-kuma:latest";
    
    autoStart = true;
    
    ports = [
      "3001:3001"  # Web arayüzü
    ];
    
    volumes = [
      "uptime-kuma:/app/data"  # Uptime Kuma verileri
    ];
    
    extraOptions = [
      "--restart=always"
    ];
  };

  # ============================================
  # ADGUARD HOME - DNS Ad Blocker
  # ============================================
  virtualisation.oci-containers.containers.adguardhome = {
    image = "adguard/adguardhome:latest";
    
    autoStart = true;
    
    ports = [
      "3000:3000"  # Web arayüzü (ilk kurulum)
      "53:53/tcp"  # DNS
      "53:53/udp"  # DNS
      "67:67/udp"  # DHCP (opsiyonel)
      "68:68/udp"  # DHCP (opsiyonel)
      "80:80/tcp"  # HTTP (admin paneli için)
      # "443:443/tcp"  # HTTPS (şimdilik kapalı, Nginx ile충돌 yapar)
      "853:853/tcp"  # DNS-over-TLS
    ];
    
    volumes = [
      "adguard_work:/opt/adguardhome/work"
      "adguard_conf:/opt/adguardhome/conf"
    ];
    
    extraOptions = [
      "--restart=always"
      "--cap-add=NET_ADMIN"  # Ağ yönetimi için gerekli
    ];
  };

  # ============================================
  # NGINX VHOST TANIMLARI
  # ============================================
  # Her servis için reverse proxy kuralım
  
  services.nginx.virtualHosts = {
    # Portainer için
    "portainer.deepshell.org" = {
      forceSSL = true;  # HTTPS'e yönlendir
      enableACME = true;  # Let's Encrypt sertifikası al
      
      locations."/" = {
        proxyPass = "https://127.0.0.1:9443";
        proxyWebsockets = true;  # WebSocket desteği
        
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          
          # SSL doğrulamasını atla (self-signed cert)
          proxy_ssl_verify off;
        '';
      };
    };
    
    # Uptime Kuma için
    "uptime.deepshell.org" = {
      forceSSL = true;
      enableACME = true;
      
      locations."/" = {
        proxyPass = "http://127.0.0.1:3001";
        proxyWebsockets = true;
        
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
    
    # AdGuard Home için
    "adguard.deepshell.org" = {
      forceSSL = true;
      enableACME = true;
      
      locations."/" = {
        proxyPass = "http://127.0.0.1:80";  # AdGuard'ın HTTP portu
        
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };

  # ============================================
  # FİREWALL - Ek portlar
  # ============================================
  networking.firewall.allowedTCPPorts = [
    3000   # AdGuard initial setup
    3001   # Uptime Kuma
    53     # DNS (AdGuard)
  ];
  
  networking.firewall.allowedUDPPorts = [
    53     # DNS (AdGuard)
    67     # DHCP (AdGuard - opsiyonel)
    68     # DHCP (AdGuard - opsiyonel)
  ];
}
