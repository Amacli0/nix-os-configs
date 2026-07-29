{pkgs, ...}: {
  home.packages = with pkgs; [
    mpv
    vlc
    sioyek
    spotify
    freetube

    # Ses Production & Utau
    openutau
    ardour
    nicotine-plus
    picard
    supersonic-wayland
    strawberry
    zrythm
    supercollider
    helvum
    (haskellPackages.ghcWithPackages (hp: with hp; [tidal]))
  ];
}
