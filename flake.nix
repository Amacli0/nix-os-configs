{
  #######################################
  #              INPUTLAR              #
  #######################################
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
  };
  #######################################
  #              OUTPUTS                #
  #######################################
  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    sops-nix,
    stylix,
    ...
  }: {
    nixosConfigurations = {
      Nixtilus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/Nixtilus/default.nix
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
        ];
      };
    };
  };
}
