#######################################
#              GAMING                 #
#######################################
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  programs = {
    steam = {
      enable = true;
    };
    gamemode.enable = true;

    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      # Unity ve modern oyunların aradığı standart Linux paketleri
      stdenv.cc.cc
      glibc
      xorg.libX11
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXext
      xorg.libXi
      xorg.libXinerama
      libGL # Kesinlikle ekle (OpenGL)
      vulkan-loader # Kesinlikle ekle (Vulkan)
      xorg.libXScrnSaver
      libglvnd
      alsa-lib
      pulseaudio
      udev
    ];
  };
}
