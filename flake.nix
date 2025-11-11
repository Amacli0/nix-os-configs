{
  #######################################
  #              INPUTLAR              #
  #######################################
  inputs = {
    #NİX PAKETLERİ
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #HYPRLAND
    hyprland.url = "github:hyprwm/Hyprland";
    #HOME MANAGER
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #SOPS NİX
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #STYLİX
    stylix.url = "github:danth/stylix";
  };
  #######################################
  #              OUTPUTS                #
  #######################################
  outputs = {
    self,
    nixpkgs,
    home-manager,
    sops-nix,
    stylix,
    ...
  }
  #######################################
  #              AYARLAMALAR              #
  #######################################
  @ inputs: {
    nixosConfigurations = {
      #NİXTİLUS
      Nixtilus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        #######################################
        #              MODUL AYARLARI         #
        #######################################
        modules = [
          # 1. Ana Yapılandırma
          ./main/configuration.nix
          # 2. SOPS-NIX Modülü
          sops-nix.nixosModules.sops

          # 3. Home Manager
          home-manager.nixosModules.home-manager

          ({
            config,
            pkgs,
            ...
          }: {
            home-manager.users.deepshell = import ./main/home.nix;
          })
          #4 Stylix Moduleri
          inputs.stylix.nixosModules.stylix
        ];
      };
      #SERVER PC
      server-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        #######################################
        #            MODUL AYARLARI           #
        #######################################
        modules = [
          # 1. Ana Yapılandırma
          ./server/configuration_server.nix
          # 2 .SOPS-NİX Modül
          sops-nix.nixosModules.sops
          # 3. Home Manager
          home-manager.nixosModules.home-manager
          ({
            config,
            pkgs,
            ...
          }: {
            home-manager.users.server-pc = import ./server/home-server.nix;
          })
        ];
      };
    };
  };
}
