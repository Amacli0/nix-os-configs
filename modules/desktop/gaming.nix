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
      libX11
      libXcursor
      libXrandr
      libXext
      libXi
      libXinerama
      libGL # Kesinlikle ekle (OpenGL)
      vulkan-loader # Kesinlikle ekle (Vulkan)
      libXScrnSaver
      libglvnd
      alsa-lib
      pulseaudio
      udev
    ];
  };
}
