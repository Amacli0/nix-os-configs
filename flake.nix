{
  #######################################
  #              INPUTLAR              #
  #######################################
  inputs = {
    #NİX PAKETLERİ
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
          ./main/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          (
            {
              config,
              pkgs,
              ...
            }: {
              home-manager.backupFileExtension = "backup";
              home-manager.users.deepshell = import ./main/home.nix;
            }
          )
        ];
      };
    };
  };
}
