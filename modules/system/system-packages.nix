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
  ];

  nixpkgs.config.allowUnfree = true;
}
