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
    firefox
    vim
    foot
  ];

  nixpkgs.config.allowUnfree = true;
}
