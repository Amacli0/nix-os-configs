#######################################
#              PACKAGES               #
#######################################
{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    sysstat
  ];
  services.flatpak.enable = true;
  nixpkgs.config.allowUnfree = true;
}
