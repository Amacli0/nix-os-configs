{pkgs, ...}: {
  home.packages = with pkgs; [
    fastfetch
    yazi
    bat
    btop
    tree
    unzip
    zip
    wl-clipboard
    ffmpegthumbnailer
    poppler
    nfs-utils
    syncthing
    zellij
    xdg-utils
    fontconfig
    commitizen
  ];
}
