# ./darwin/default.nix
{ inputs, ... }: {
  imports = [
    inputs.home-manager.darwinModules.home-manager

    ./system.nix
    ./packages.nix
    ./macos.nix
    ./homebrew.nix
    ./users.nix
  ];

  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
  ];


  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.mb = {
    imports = [
      ../home
    ];
  };

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
}
