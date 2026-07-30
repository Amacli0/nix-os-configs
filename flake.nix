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

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  #######################################
  #              OUTPUTS                #
  #######################################
  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    stylix,
    noctalia,
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
