# Darwin-Einstiegspunkt: System-Module + Home-Manager Wiring
{ inputs, ... }:
{
  imports = [
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

  home-manager.extraSpecialArgs = { inherit inputs; };

  home-manager.users.mb = {
    imports = [
      ../home
    ];
  };

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
}
