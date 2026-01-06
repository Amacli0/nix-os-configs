#######################################
#              PACKAGES               #
#######################################
{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    git
    age
    sops
    alejandra
    kitty
    firefox
    vim
    niri
  ];

  nixpkgs.config.allowUnfree = true;
}
