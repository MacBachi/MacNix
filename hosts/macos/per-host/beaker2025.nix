# per-Host Overlay: beaker2025 (privat, aarch64)
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
