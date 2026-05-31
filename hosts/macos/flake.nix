{
  description = "MacBachi nix-darwin flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
    # Per-Host Konfiguration. Wer einen neuen Host hinzufuegt, traegt ihn hier
    # ein und legt optional ./hosts/<hostname>.nix als 'extras'-Modul an.
    hosts = {
      rizzo2025       = { system = "aarch64-darwin"; user = "mb";       uid = 501; extras = [ ./per-host/rizzo2025.nix ]; };
      beaker2025      = { system = "aarch64-darwin"; user = "mb";       uid = 501; extras = [ ./per-host/beaker2025.nix ]; };
      scooter2016     = { system = "x86_64-darwin";  user = "mb";       uid = 501; extras = [ ./per-host/scooter2016.nix ]; };
      PN1030UZ2568748 = { system = "aarch64-darwin"; user = "U1131JN"; uid = 502; extras = [ ./per-host/PN1030UZ2568748.nix ]; };
    };

    # Darwin System Builder: nix-darwin + home-manager + mac-app-util.
    # user/uid werden via specialArgs an alle Module durchgereicht.
    mkDarwinConfig = hostname: cfg: nix-darwin.lib.darwinSystem {
      system = cfg.system;
      specialArgs = { inherit inputs; inherit (cfg) user uid; };
      modules = [
        ./darwin
        home-manager.darwinModules.home-manager
        (if cfg.system == "aarch64-darwin" then mac-app-util.darwinModules.default else {})
        ({ pkgs, ... }: {
          home-manager.sharedModules =
            if cfg.system == "aarch64-darwin" then [ mac-app-util.homeManagerModules.default ] else [];
        })
      ] ++ cfg.extras;
    };

    # Standalone Home-Manager Builder (fuer Debugging einzelner HM-Module).
    mkHomeConfig = hostname: cfg: home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${cfg.system};
      extraSpecialArgs = { inherit inputs; inherit (cfg) user uid; };
      modules = [
        ./home/default.nix
        {
          home.username = cfg.user;
          home.homeDirectory = "/Users/${cfg.user}";
        }
      ];
    };

  in {
    darwinConfigurations      = builtins.mapAttrs mkDarwinConfig hosts;
    homeManagerConfigurations = builtins.mapAttrs mkHomeConfig hosts;
  };
}
