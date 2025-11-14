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
    #NixVİm
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    nixvim,
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
          ./main/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          nixvim.nixosModules.nixvim
          ({
            config,
            pkgs,
            ...
          }: {
            home-manager.users.deepshell = import ./main/home.nix;
          })
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
          ./server/configuration_server.nix
          sops-nix.nixosModules.sops
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
