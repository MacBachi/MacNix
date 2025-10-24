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
    let
      baseModules = [
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
      aarch64_hosts = [
        "rizzo2025"
        "beaker2025"
      ];
    in
    {
      darwinConfigurations = builtins.listToAttrs (
        map (host: {
          name = host;
          value = nix-darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            specialArgs = { inherit inputs; };
            modules = baseModules;
          };
        }) aarch64_hosts
      );
    };
}


