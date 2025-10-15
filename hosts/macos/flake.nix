# ./flake.nix
{
  description = "Markus zenful darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nix-vscode-extensions,
      home-manager,
      nixpkgs,
      mac-app-util,
      ...
    }:
    {
      darwinConfigurations."rizzo2025" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./darwin
          mac-app-util.darwinModules.default
          home-manager.darwinModules.home-manager
          (
            {
              pkgs,
              config,
              inputs,
              ...
            }:
            {
              home-manager.sharedModules = [
                mac-app-util.homeManagerModules.default
              ];
            }
          )
        ];
      };
      darwinConfigurations."beaker2025" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./darwin
          mac-app-util.darwinModules.default
          home-manager.darwinModules.home-manager
          (
            {
              pkgs,
              config,
              inputs,
              ...
            }:
            {
              home-manager.sharedModules = [
                mac-app-util.homeManagerModules.default
              ];
            }
          )
        ];
      };
    };
}
