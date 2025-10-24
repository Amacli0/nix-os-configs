{
  description = "NixOS configuration for Nixtilus with Home Manager and Hyprland";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
	sops-nix.url = "github:Mic92/sops-nix";
	sops-nix.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }@inputs: {
    nixosConfigurations = {

    Nixtilus = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # sistem mimarini belirt (gerekli!)
      specialArgs = { inherit inputs; };
      modules = [
        ./main/configuration.nix
        sops-nix.nixosModules.sops  
        home-manager.nixosModules.home-manager

        # home.nix'i dahil ediyoruz
        ({ config, pkgs, ... }: {
          home-manager.users.deepshell = import ./main/home.nix;
        })
      ];
    };
	server-pc = nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	specialArgs = { inherit inputs; };
         
 modules = [
      ./server/hardware-configuration.nix
      ./server/configuration_server.nix
       sops-nix.nixosModules.sops  
      ];




	};



    };
  };
}

