{ config, pkgs, lib, ... }:

# ...
{
services.ddclient = {
  enable = true;
  
  # ddclient'ın 300 saniyede bir (5 dakikada bir) kontrol yapmasını sağla
  daemon = 300; 

  configuration = ''
    # IP adresi tespiti: Genel IPv4 adresini bir web servisi üzerinden al
    use=web, web=ipify-ipv4

    # ===============================================
    # Cloudflare Protokol Konfigürasyonu
    # ===============================================
    
    # Protokol: Cloudflare'ı kullan
    protocol=cloudflare
    
    # Cloudflare hesabının kayıtlı olduğu e-posta adresi (login)
    login=deepshell@proton.me
    
    # Parolayı /etc/nixos/ddclient-secret.txt dosyasından oku
    # Bu, API Anahtarını veya Token'ı temsil eder
    passwordfile=/home/server-pc/server/ddns_sec.txt
    
    # Güncellenecek alan adları:
    # Birden fazla alan adını yan yana virgülle ayırarak güncelleyebilirsin.
    # example.com: Ana Alan Adı (Zone)
    # ddns.example.com: Güncellenecek spesifik A kaydı (Hostname)
    deepshell.org, ddns.example.com
    
  '';
};

#... dosyanın kalanı ...

}
