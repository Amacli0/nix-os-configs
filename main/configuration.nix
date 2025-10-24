#Nixos config File
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
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      timeout = 15;

      systemd-boot = {
        enable = false;
      };

      efi.canTouchEfiVariables = true;

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
    };
  };

  networking = {
    hostName = "Nixtilus";
    networkmanager.enable = true;
  };
  time.timeZone = "Europe/Istanbul";

  i18n.defaultLocale = "en_US.UTF-8";

  security.pki.certificates = [
    (builtins.readFile ./MEB_SERTIFIKASI.pem)
  ];

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = false;
  };

  services = {
    tailscale ={
    enable = true;
};
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

    openssh.enable = true;

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



  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  programs.zsh.enable = true;




  nix.settings.experimental-features = ["nix-command" "flakes"];


  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    age.keyFile = "/root/.config/sops/age/keys.txt";



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
  environment.systemPackages = with pkgs; [
    alejandra
    protonvpn-cli_2
    age
    sops
  ];
 








 system.stateVersion = "25.05";
}
