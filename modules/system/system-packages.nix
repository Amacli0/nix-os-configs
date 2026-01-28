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
  services.flatpak.enable = true;
  nixpkgs.config.allowUnfree = true;
}
