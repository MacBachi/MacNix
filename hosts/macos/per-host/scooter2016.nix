# per-Host Overlay: scooter2016 (privat, x86_64)
{ user, ... }:
{
  imports = [
    ../darwin/homebrew-shared.nix
    ../darwin/homebrew-private.nix
  ];

  home-manager.users.${user}.imports = [
    ../home/packages-shared.nix
    ../home/packages-private.nix
  ];
}
