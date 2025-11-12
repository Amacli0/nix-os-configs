{
  config,
  pkgs,
  lib,
  ...
}: {
  #######################################
  #            BASIC SETTİNGS           #
  #######################################
  home.username = "deepshell";
  home.homeDirectory = "/home/deepshell";
  home.stateVersion = "25.05";
  #######################################
  #            IMPORTS                  #
  #######################################
  imports = [
    ./home-modules/hyprland.nix
    ./home-modules/stylinx.nix
    ./home-modules/packages.nix
    inputs.stylix.homeManagerModules.stylix
    ./home-modules/apps/obs.nix
    ./home-modules/apps/firefox.nix
    ./home-modules/apps/git.nix
    ./home-modules/apps/kitty.nix
    ./home-modules/apps/waybar.nix
    ./home-modules/apps/zsh.nix
    ./home-modules/apps/neovim.nix
  ];

  #######################################
  #            POLKİT                   #
  #######################################
  systemd.user.services.polkit-gnome-agent = {
    Unit = {
      Description = "Polkit GNOME Authentication Agent";
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
