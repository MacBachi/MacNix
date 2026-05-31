# per-Host Overlay: rizzo2025 (privat, aarch64)
# Importiert die shared- + private-Fragmente. Workmac wuerde stattdessen
# *-work.nix importieren - daher die explizite Aufteilung.
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
