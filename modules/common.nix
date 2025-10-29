{
  config,
  pkgs,
  ...
}: {
  networking = {
    networkmanager = {
      enable = true;
    };
  };

  time.timeZone = "Europe/Istanbul";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    keyMap = "trq";
    font = "Lat2-Terminus16";
  };

  services = {
    tailscale = {
      enable = true;
    };

    openssh = {
      enable = true;
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    alejandra
    git
    neovim
    age
    sops
  ];




}
