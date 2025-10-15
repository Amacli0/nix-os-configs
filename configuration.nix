#Nixos config File
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:



{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  boot.loader = {
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
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "Nixtilus";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Istanbul";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  i18n.defaultLocale = "en_US.UTF-8";

 
  security.pki.certificates = [
    (builtins.readFile ./MEB_SERTIFIKASI.pem)
  ];





  console = {
    font = "Lat2-Terminus16";
    #  keyMap = "tr";
    useXkbConfig = false;
  };

  services = {
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

printing= {
enable = true;
drivers = [ pkgs.hplip pkgs.cups ];
};
blueman.enable = true;





};
  programs.hyprland.enable = true;
  programs.zsh.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

 
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
    packages = with pkgs; [
      tree
    ];
  };

  environment.shells = [pkgs.zsh];
  environment.systemPackages = with pkgs; [
    alejandra
  ];

  #services.gpg-agent = {
  #enable=true;
  #enableSshSupport = true;
  #};

  # programs.mtr.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  system.stateVersion = "25.05";
}
