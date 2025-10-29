# /home/deepshell/nix-os-configs/flake.nix (Temizlenmiş Versiyon)

{
  description = "NixOS configuration for Nixtilus with Home Manager and Hyprland";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
	

  };

  outputs = { self, nixpkgs, home-manager, sops-nix, stylix, ... }@inputs: {
    nixosConfigurations = {
      Nixtilus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        
        modules = [
          # 1. Ana Yapılandırma
          ./main/configuration.nix
          
          # 2. SOPS-NIX Modülü (Şimdi liste içinde temiz bir şekilde)
          sops-nix.nixosModules.sops

          # 3. Home Manager Modülü
          home-manager.nixosModules.home-manager

          # 4. Home Manager kullanıcı ayarlarının olduğu kısım (anonymous module)
          ({ config, pkgs, ... }: {
            home-manager.users.deepshell = import ./main/home.nix;
          })
	  #5 Stylix Moduleri
	  inputs.stylix.nixosModules.stylix
        ];
      };

      server-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./server/configuration_server.nix
          # SERVER tarafına da sops-nix eklenmeli, unutmaman için not.
           sops-nix.nixosModules.sops
        ];
      };
    };
  };
}
