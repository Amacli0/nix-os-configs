{
  cloudflare = {
    # Zone ID: Cloudflare dashboard -> Domain seç -> sağ tarafta "Zone ID"
    zoneId = "a4f679e8996821f714c0bea1fdb33737";
    
    # API Token: Cloudflare dashboard -> My Profile -> API Tokens -> Create Token
    # "Edit zone DNS" template'ini kullanın
    apiToken = "mCivOFEn0jdRFu7Lg-P0HtM7fUaIakOgv-luio2t";
    
    # Ana domain adınız (örn: example.com)
    domain = "deepshell.org";
    
    # Güncellenecek DNS kaydı (örn: home.example.com veya sadece example.com için @)
    recordName = "@";
  };
}
