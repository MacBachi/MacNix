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
    # Gemeinsame Basis-Module, die für alle Hosts gelten
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
            builtins.listToAttrs (
              map (host: {
                name = host;
                value = nix-darwin.lib.darwinSystem {
                  system = system;
                  specialArgs = { inherit inputs; };
                  # Lädt nur die Basis-Module, um den Fehler der fehlenden Host-Datei zu vermeiden
                  modules = baseModules; 
                };
              }) hosts
            );

        in
        {
          darwinConfigurations =
            # Apple Silicon Hosts
        (mkHostConfigs "aarch64-darwin" aarch64_hosts)
        // # Intels Hosts
               (mkHostConfigs "x86_64-darwin" x86_64_hosts);
    };
}
