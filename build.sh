#!/usr/bin/env bash

# Matrix Kurulum Scripti
# Bu script Matrix Synapse için ilk konfigürasyonu oluşturur

set -e

echo "=== Matrix Synapse İlk Kurulum ==="

# Renkli çıktı için
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Veritabanı şifresini SOPS'tan oku
MATRIX_DB_PASSWORD=$(cat /run/secrets/matrix_db_passwd)

echo -e "${YELLOW}1. Matrix dizinlerini oluşturuyoruz...${NC}"
sudo mkdir -p /var/lib/matrix/synapse
sudo mkdir -p /var/lib/matrix/element
sudo mkdir -p /var/lib/matrix-db

echo -e "${YELLOW}2. Synapse konfigürasyon dosyası oluşturuluyor...${NC}"
sudo tee /var/lib/matrix/synapse/homeserver.yaml > /dev/null <<EOF
# Matrix Synapse Konfigürasyon Dosyası
server_name: "deepshell.org"
pid_file: /data/homeserver.pid
web_client_location: https://element.deepshell.org
public_baseurl: https://matrix.deepshell.org

# Dinleme Ayarları
listeners:
  - port: 8008
    tls: false
    type: http
    x_forwarded: true
    bind_addresses: ['0.0.0.0']
    
    resources:
      - names: [client, federation]
        compress: false

# Veritabanı Ayarları
database:
  name: psycopg2
  args:
    user: synapse_user
    password: ${MATRIX_DB_PASSWORD}
    database: synapse
    host: matrix-db
    port: 5432
    cp_min: 5
    cp_max: 10

# Log Ayarları
log_config: "/data/deepshell.org.log.config"

# Medya Ayarları
media_store_path: /data/media_store
max_upload_size: 50M
max_image_pixels: 32M

# Kayıt Ayarları
enable_registration: true
enable_registration_without_verification: false
registration_shared_secret: "BURAYA_GÜVENLİ_BİR_ŞİFRE_YAZIN"

# Güvenlik
macaroon_secret_key: "BURAYA_BAŞKA_GÜVENLİ_BİR_ŞİFRE_YAZIN"
form_secret: "BURAYA_ÜÇÜNCÜ_GÜVENLİ_BİR_ŞİFRE_YAZIN"

# Federation Ayarları
suppress_key_server_warning: true

# Trusted Key Servers
trusted_key_servers:
  - server_name: "matrix.org"

# Rate Limiting
rc_message:
  per_second: 0.2
  burst_count: 10

rc_registration:
  per_second: 0.17
  burst_count: 3

rc_login:
  address:
    per_second: 0.17
    burst_count: 3
  account:
    per_second: 0.17
    burst_count: 3
  failed_attempts:
    per_second: 0.17
    burst_count: 3

# Notifikasyonlar
enable_notifs: true

# URL Preview (Opsiyonel)
url_preview_enabled: true
url_preview_ip_range_blacklist:
  - '127.0.0.0/8'
  - '10.0.0.0/8'
  - '172.16.0.0/12'
  - '192.168.0.0/16'

# TURN Sunucusu (Video/Ses çağrıları için - opsiyonel)
# turn_uris: []
# turn_shared_secret: ""
# turn_user_lifetime: 86400000

# Email Ayarları (Şifre sıfırlama için - opsiyonel)
# email:
#   smtp_host: smtp.gmail.com
#   smtp_port: 587
#   smtp_user: "your-email@gmail.com"
#   smtp_pass: "your-password"
#   notif_from: "Matrix <your-email@gmail.com>"
#   enable_notifs: true
EOF

echo -e "${YELLOW}3. Log konfigürasyonu oluşturuluyor...${NC}"
sudo tee /var/lib/matrix/synapse/deepshell.org.log.config > /dev/null <<EOF
version: 1

formatters:
  precise:
    format: '%(asctime)s - %(name)s - %(lineno)d - %(levelname)s - %(request)s - %(message)s'

handlers:
  console:
    class: logging.StreamHandler
    formatter: precise

root:
  level: INFO
  handlers: [console]

loggers:
  synapse.storage.SQL:
    level: INFO
EOF

echo -e "${YELLOW}4. Element Web konfigürasyonu oluşturuluyor...${NC}"
sudo tee /var/lib/matrix/element/config.json > /dev/null <<EOF
{
  "default_server_config": {
    "m.homeserver": {
      "base_url": "https://matrix.deepshell.org",
      "server_name": "deepshell.org"
    },
    "m.identity_server": {
      "base_url": "https://vector.im"
    }
  },
  "brand": "Element",
  "integrations_ui_url": "https://scalar.vector.im/",
  "integrations_rest_url": "https://scalar.vector.im/api",
  "integrations_widgets_urls": [
    "https://scalar.vector.im/_matrix/integrations/v1",
    "https://scalar.vector.im/api",
    "https://scalar-staging.vector.im/_matrix/integrations/v1",
    "https://scalar-staging.vector.im/api",
    "https://scalar-staging.riot.im/scalar/api"
  ],
  "hosting_signup_link": "https://element.io/matrix-services?utm_source=element-web&utm_medium=web",
  "bug_report_endpoint_url": "https://element.io/bugreports/submit",
  "uisi_autorageshake_app": "element-auto-uisi",
  "showLabsSettings": true,
  "piwik": false,
  "roomDirectory": {
    "servers": ["matrix.org", "deepshell.org"]
  },
  "enable_presence_by_hs_url": {
    "https://matrix.org": false,
    "https://matrix-client.matrix.org": false
  },
  "terms_and_conditions_links": [
    {
      "url": "https://element.io/privacy",
      "text": "Privacy Policy"
    },
    {
      "url": "https://element.io/terms-of-service",
      "text": "Terms of Service"
    }
  ],
  "hostSignup": {
    "brand": "Element Home",
    "url": "https://ems.element.io/element-home/in-app-loader"
  },
  "sentry": {
    "dsn": "https://029a0eb289f942508ae0fb17935bd8c5@sentry.matrix.org/6",
    "environment": "production"
  },
  "posthog": {
    "project_api_key": "phc_Jzsm6DTm6V2705zeU5dcNvQDlonOR68XvX2sh1sEOHO",
    "api_host": "https://posthog.element.io"
  },
  "features": {},
  "map_style_url": "https://api.maptiler.com/maps/streets/style.json?key=fU3vlMsMn4Jb6dnEIFsx",
  "disable_custom_urls": false,
  "disable_guests": false,
  "disable_login_language_selector": false,
  "disable_3pid_login": false,
  "default_country_code": "TR",
  "setting_defaults": {
    "breadcrumbs": true
  }
}
EOF

echo -e "${YELLOW}5. Dosya izinlerini ayarlıyoruz...${NC}"
sudo chown -R 991:991 /var/lib/matrix/synapse
sudo chown -R 999:999 /var/lib/matrix-db
sudo chmod -R 755 /var/lib/matrix/element

echo -e "${GREEN}✓ Matrix konfigürasyon dosyaları oluşturuldu!${NC}"
echo ""
echo -e "${YELLOW}ÖNEMLİ: homeserver.yaml dosyasındaki güvenlik anahtarlarını değiştirmeyi unutmayın!${NC}"
echo "Dosya yolu: /var/lib/matrix/synapse/homeserver.yaml"
echo ""
echo -e "${YELLOW}Güvenli rastgele şifreler oluşturmak için:${NC}"
echo "openssl rand -hex 32"
echo ""
echo -e "${GREEN}Şimdi NixOS konfigürasyonunu yeniden oluşturabilirsiniz:${NC}"
echo "sudo nixos-rebuild switch"
