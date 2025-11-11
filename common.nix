{
  config,
  pkgs,
  ...
}: {
  #######################################
  #            SERVER & MAİN            #
  #######################################
  networking = {
    networkmanager = {
      enable = true;
    };
  };
  #######################################
  #            Zaman ve Klavye          #
  #######################################
  time.timeZone = "Europe/Istanbul";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    keyMap = "trq";
    font = "Lat2-Terminus16";
  };
  #######################################
  #              SERVİSLER              #
  #######################################
  services = {
    tailscale = {
      enable = true;
    };

    openssh = {
      enable = true;
    };
  };
  #######################################
  #              NİX FLAKE              #
  #######################################
  nix.settings.experimental-features = ["nix-command" "flakes"];
  #######################################
  #              PAKETLER              #
  #######################################
  environment.systemPackages = with pkgs; [
    alejandra
    git
    neovim
    age
    sops
    btop
    fastfetch
    tree
  ];

  allowUnfree = true;
}
