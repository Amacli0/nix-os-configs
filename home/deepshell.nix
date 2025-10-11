# /etc/nixos/home/deepshell.nix dosyası
{ config, pkgs, ... }:

{
  home.stateVersion = "25.05"; # Örneğin, bir önceki kararlı sürüm

  # Kullanıcıya Özgü Paketler
  home.packages = with pkgs; [
    neovim
    kitty
    git
    bitwarden-desktop
    wget
    fastfetch
  ];

  # Kullanıcıya Özgü Entegrasyonlar ve Ayarlar
  
  # A. GnuPG ve SSH Entegrasyonu (Sadece Kullanıcı Oturumu İçin)
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "qt"; # Veya curses, gtk gibi bir pinentry arayüzü seçebilirsin.
  };

  # B. Terminal Emülatörü Kitty'nin Konfigürasyonu
  programs.kitty = {
    enable = true;
    # ... buraya Kitty'nin diğer ayarlarını yazabilirsin.
  };

  # C. Git Ayarları
  programs.git = {
    enable = true;
    userName = "Deepshell User";
    userEmail = "deepsheel@proton.me";
  };
  programs.firefox = {
    enable = true;

  };
  # D. Hyprland Ayarları (Eğer Hyprland'i Home Manager ile yönetmek istiyorsan)
   programs.hyprland.enable = true; # Eğer sistemden Home Manager'a taşırsan.

}
