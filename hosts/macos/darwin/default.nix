# ./darwin/default.nix
{ inputs, ... }: {
  imports = [
    # Importiere Home Manager Modul für nix-darwin
    inputs.home-manager.darwinModules.home-manager

    # Importiere deine lokalen System-Module
    ./system.nix
    ./packages.nix
    ./macos.nix
    ./homebrew.nix
    ./users.nix
  ];

  # Home Manager Konfiguration
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.mb = {
    imports = [
      ../home
    ];
  };


  # Setze den Git-Hash für die `darwin-version`.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
}
