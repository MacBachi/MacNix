{
  description = "MacBachi nix-darwin flake";

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
    lualine-src = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nix-vscode-extensions, home-manager, nixpkgs, mac-app-util, ... }:
  let
    aarch64_hosts = [ "rizzo2025" "beaker2025" ];
    x86_64_hosts  = [ "scooter2016" ];
    user = "mb";

    # Darwin System Builder: nix-darwin + home-manager + mac-app-util
    mkHostConfigs = system: hosts: let
      currentModules = [
        ./darwin
        home-manager.darwinModules.home-manager
        (if system == "aarch64-darwin" then mac-app-util.darwinModules.default else {})
        ({ pkgs, ... }: {
           home-manager.sharedModules =
             if system == "aarch64-darwin" then [ mac-app-util.homeManagerModules.default ] else [];
        })
      ];
    in builtins.listToAttrs ( map (host: {
        name = host;
        value = nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = currentModules;
        };
      }) hosts );

    # Standalone Home-Manager Builder (fuer Debugging)
    mkHomeConfigs = system: hosts: builtins.listToAttrs (
      map (host: {
        name = host;
        value = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home/default.nix
            {
               home.username = user;
               home.homeDirectory = "/Users/${user}";
            }
          ];
        };
      }) hosts
    );

  in {
    darwinConfigurations =
      (mkHostConfigs "aarch64-darwin" aarch64_hosts) //
      (mkHostConfigs "x86_64-darwin" x86_64_hosts);

    homeManagerConfigurations =
      (mkHomeConfigs "aarch64-darwin" aarch64_hosts) //
      (mkHomeConfigs "x86_64-darwin" x86_64_hosts);
  };
}
