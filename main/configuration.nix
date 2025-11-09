{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  #######################################
  #            IMPORTS                  #
  #######################################
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    inputs.home-manager.nixosModules.home-manager
  ];
  #######################################
  #                BOOT                 #
  #######################################
  virtualisation = {
    spiceUSBRedirection.enable = true;

    libvirtd = {
      enable = true;
      qemuPackage = pkgs.qemu_kvm;
      onBoot = "start";
      onShutdown = "shutdown";
    };
  };
  boot = {
    kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
    ];
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
  #######################################
  #               FONT                  #
  #######################################
  fonts.packages = with pkgs; [
    monocraft
    pkgs.nerd-fonts.fira-code
  ];

  fonts.fontconfig.enable = true;
  #######################################
  #            NETWORK                  #
  #######################################
  networking = {
    hostName = "Nixtilus";
    nameservers = ["127.0.0.1" "::1"];
  };
  #######################################
  #            SERTİFİKA                #
  #######################################
  security.pki.certificates = [
    (builtins.readFile ./MEB_SERTIFIKASI.pem)
  ];
  #######################################
  #            SERVİCES                 #
  #######################################
  services = {
    dnscrypt-proxy = {
      enable = true;
      settings = {
        listen_addresses = ["127.0.0.1:53" "[::1]:53"];
      };
    };

    zapret = {
      enable = true;
      params = [
        "--dpi-desync=fake"
        "--dpi-desync-ttl=8"
      ];
    };
    #######################################
    #           EKRAN KARTI               #
    #######################################
    xserver.videoDriver = ["amdgpu"];
    #######################################
    #            DATABASES                  #
    #######################################
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
    #######################################
    #            SOUND  ETC               #
    #######################################
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
  #######################################
  #            HARDWARES                #
  #######################################
  hardware = {
    bluetooth.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  #######################################
  #            PROGRAMS                 #
  #######################################
  programs = {
    virt-manager.enable = true;
    #######################################
    #            Hyprland                  #
    #######################################
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };
    # ZSH
    zsh.enable = true;
    #STEAM
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };
  #######################################
  #            HOME MANAGER             #
  #######################################
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "deepshell" = ./home.nix;
    };
  };
  #######################################
  #            KULLANICILAR             #
  #######################################
  users.users.deepshell = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "audio" "video libvirt kvm"]; # Enable ‘sudo’ for the user.
  };

  #######################################
  #            PAKETLER                 #
  #######################################
  environment.systemPackages = with pkgs; [
    hyprpolkitagent
    tor-browser-bundle-bin
  ];
  environment.shells = [pkgs.zsh];
  #######################################
  #            STYLE                  #
  #######################################
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  #######################################
  #            SECURİTY                 #
  #######################################
  nixpkgs.config.allowUnfree = true;

  security.polkit.enable = true;
  #######################################
  #            SİSTEM VERSİON           #
  #######################################
  system.stateVersion = "25.05";
}
