{
  description = "NixOS configuration for Nixtilus with Home Manager and Hyprland";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      Nixtilus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./main/configuration.nix
          home-manager.nixosModules.home-manager
          ({ config, pkgs, ... }: {
            home-manager.users.deepshell = import ./main/home.nix;
          })
        ];
      };
      
      server-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./server/configuration_server.nix
        ];
      };
    };
  };
}
