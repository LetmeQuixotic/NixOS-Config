{
  description = "NixOS flake-configuration with Noctalia";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; 
    };

    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

  }; 

 
  outputs = inputs@{ self, nixpkgs, nixvim, home-manager, flake-utils, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
	nixvim.nixosModules.nixvim
        ./quickshell.nix
        ./ollama.nix
        ./podman.nix
        ./napcat.nix
        ./koishi.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.qimel = import ./home.nix;
        }
      ];
    }; 
  };
}
