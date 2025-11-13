{
  config,
  pkgs,
  lib,
  ...
}: {
  #######################################
  #            BASIC SETTİNGS           #
  #######################################
  home.username = "server-pc";
  home.homeDirectory = "/home/server-pc";
  home.stateVersion = "25.05";

  programs = {
    zsh.enable = true;
    tmux.enable = true;
    git = {
      enable = true;
settings = {    
  user = {
        name = "Mehmet Şükrü Bilgiç";
        email = "deepshell@proton.me";
      };
    };
};
    neovim.enable = true;
  };

  home.packages = with pkgs; [
    # Gözetim (Monitoring)
    tree
    fastfetch
    btop

    # Arama/Filtreleme
    ripgrep # Hızlı dosya içeriği arama
    fd # Hızlı dosya bulma

    # Veri İşleme
    jq # JSON ayrıştırma
    yq # YAML ayrıştırma

    # Güvenlik/DevOps
    age
    sops
  ];
}
