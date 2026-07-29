{pkgs, ...}: {
  home.packages = with pkgs; [
    vitetris
    godot
    pokemmo-installer
    wineWow64Packages.stable
    retroarch-free
    antimicrox
    lutris
    ruffle
    itch
    supertuxkart
    blender
  ];
}
