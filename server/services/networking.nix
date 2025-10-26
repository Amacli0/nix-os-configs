{ config, lib, pkgs, ... }:
{
  # ============================================
  # CLOUDFLARE DDNS - Dinamik IP güncelleme
  # ============================================
  # Cloudflare'de A kaydını otomatik güncelleyen systemd servisi
  systemd.services.cloudflare-ddns = {
    description = "Cloudflare DDNS Updater";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    
    # Her 5 dakikada bir çalıştır
    startAt = "*:0/5";
    
    serviceConfig = {
      Type = "oneshot";
      # Secrets dosyasından email ve token'ı yükle
      EnvironmentFile = config.sops.secrets.cloudflare_env.path;
    };
    
    script = ''
      # Mevcut public IP'yi al
      CURRENT_IP=$(${pkgs.curl}/bin/curl -s https://api.ipify.org)
      
      # Cloudflare'deki mevcut IP'yi al
      ZONE_ID=$(${pkgs.curl}/bin/curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=deepshell.org" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
        -H "Content-Type: application/json" | ${pkgs.jq}/bin/jq -r '.result[0].id')
      
      RECORD_ID=$(${pkgs.curl}/bin/curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=deepshell.org&type=A" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
        -H "Content-Type: application/json" | ${pkgs.jq}/bin/jq -r '.result[0].id')
      
      # IP'yi güncelle
      ${pkgs.curl}/bin/curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
        -H "Content-Type: application/json" \
        --data "{\"type\":\"A\",\"name\":\"deepshell.org\",\"content\":\"$CURRENT_IP\",\"ttl\":120,\"proxied\":false}"
      
      echo "IP updated to $CURRENT_IP"
    '';
  };

  # Cloudflare credentials için secret tanımla
  sops.secrets.cloudflare_env = {
    sopsFile = ../secrets/secrets.yaml;
    format = "yaml";
    # Dosya formatı: key=value şeklinde olacak
    # Script bu dosyayı okuyup environment variable olarak kullanacak
  };

  # ============================================
  # TAILSCALE - Güvenli mesh network
  # ============================================
  services.tailscale = {
    enable = true;
    # Port 41641 UDP - firewall'da açık
    # Tailscale otomatik başlayacak
  };

  # Tailscale'i başlat ve exit node olarak ayarla (opsiyonel)
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig.Type = "oneshot";
    
    script = ''
      # Tailscale'e bağlanma durumunu kontrol et
      sleep 2
      status="$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then
        exit 0
      fi
      
      # İlk kurulumda bu komutu manuel çalıştırman gerekecek:
      # sudo tailscale up --advertise-exit-node --ssh
      echo "Tailscale is not connected. Run: sudo tailscale up"
    '';
  };

  # ============================================
  # WIREGUARD - VPN Server
  # ============================================
  networking.wireguard.interfaces = {
    wg0 = {
      # WireGuard interface'i oluştur
      ips = [ "10.100.0.1/24" ];  # VPN'deki sunucu IP'si
      listenPort = 51820;  # WireGuard portu
      
      # Private key'i secrets'tan yükle
      privateKeyFile = config.sops.secrets.wireguard_private_key.path;
      
      # Şimdilik boş peer listesi - sonra client eklerken dolduracağız
      peers = [
        # Örnek peer yapısı (şimdilik comment):
        # {
        #   # Client'ın public key'i
        #   publicKey = "client_public_key_buraya";
        #   # Client'a verilen IP
        #   allowedIPs = [ "10.100.0.2/32" ];
        # }
      ];
      
      # Paket yönlendirme ayarları
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';
      
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';
    };
  };

  # WireGuard için secret tanımla
  sops.secrets.wireguard_private_key = {
    sopsFile = ../secrets/secrets.yaml;
    format = "yaml";
  };

  # IP Forwarding'i aktif et (VPN için gerekli)
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # ============================================
  # EK PAKETLER
  # ============================================
  environment.systemPackages = with pkgs; [
    wireguard-tools  # wg komutları için
    jq              # JSON parsing için (DDNS script'inde kullanıyoruz)
  ];
}
