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
      # Hosts mit ARM-Architektur (Apple Silicon)
      aarch64_hosts = [
        "rizzo2025"
        "beaker2025"
      ];
      
      # Hosts mit Intel-Architektur (x86_64)
      x86_64_hosts = [
        "scooter2016"
      ];
      
      # Generiert darwinConfigurations für eine bestimmte Architektur
      mkHostConfigs = system: hosts:
        let
          # Definiert die Module basierend auf dem 'system' Argument
          currentModules = [
            ./darwin
            home-manager.darwinModules.home-manager
            
            # Bedingte Inklusion des mac-app-util Darwin-Moduls
            (
              if system == "aarch64-darwin" then
                mac-app-util.darwinModules.default
              else
                {} # Leeres Modul für x86_64
            )

            # Home-Manager Modul (muss hier neu definiert werden, um 'system' zu prüfen)
            (
              {
                pkgs,
                config,
                inputs,
                ...
              }:
              let
                # Bedingte Inklusion des mac-app-util Home-Manager Moduls
                hmUtilModule = 
                  if system == "aarch64-darwin"
                  then [ mac-app-util.homeManagerModules.default ]
                  else [];
              in
              {
                home-manager.sharedModules = hmUtilModule;
              }
            )
          ];
        in
        builtins.listToAttrs (
          map (host: {
            name = host;
            value = nix-darwin.lib.darwinSystem {
              system = system;
              specialArgs = { inherit inputs; };
              modules = currentModules; 
            };
          }) hosts
        );

    in
    {
      darwinConfigurations =
        # Apple Silicon Hosts
        (mkHostConfigs "aarch64-darwin" aarch64_hosts)
        # Intels Hosts
        // (mkHostConfigs "x86_64-darwin" x86_64_hosts);
    };
}
