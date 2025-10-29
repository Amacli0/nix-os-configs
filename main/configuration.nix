{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    ../modules/common.nix
  ];

boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      timeout = 15;

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };

      systemd-boot = {
        enable = false;
      };
    };
  };




  fonts.packages = with pkgs; [
    monocraft
  ];

  fonts.fontconfig.enable = true;

  networking = {
    hostName = "Nixtilus";
  };

  security.pki.certificates = [
    (builtins.readFile ./MEB_SERTIFIKASI.pem)
  ];

  services = {
    postgresql = {
      enable = true;

      ensureUsers = [
        {
          name = "MyData";

          ensureDBOwnership = true;
          ensureClauses.createdb = true;
        }
      ];
      ensureDatabases = [
        "MyData"
        "test1"
        "deepshell"
      ];

      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
      '';
    };

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };

    libinput.enable = true;

    printing = {
      enable = true;
      drivers = [pkgs.hplip pkgs.cups];
    };
  };

  hardware.bluetooth.enable = true;

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };
    zsh.enable = true;
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "deepshell" = ./home.nix;
    };
  };

  users.users.deepshell = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "audio" "video"]; # Enable ‘sudo’ for the user.
  };

  environment.shells = [pkgs.zsh];



stylix.enable = true;
stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/mellow_purple.yaml";










  system.stateVersion = "25.05";
}
