# Darwin-Einstiegspunkt: System-Module + Home-Manager Wiring
{ inputs, user, ... }:
{
  imports = [
    ./system.nix
    ./packages.nix
    ./macos.nix
    ./onepassword.nix
    # homebrew-{shared,private,work}.nix wandern via per-host/HOSTNAME.nix rein
    ./users.nix
  ];

  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.extraSpecialArgs = { inherit inputs; };

  home-manager.users.${user} = {
    imports = [
      ../home
    ];
  };

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
}
