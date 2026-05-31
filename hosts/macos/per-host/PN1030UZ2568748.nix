# per-Host Overlay: PN1030UZ2568748 (workmac, aarch64)
# Importiert shared + work (NICHT private). Tools die nur auf privaten Macs
# Sinn machen werden in Phase 3b aus shared nach private verschoben.
{ user, ... }:
{
  imports = [
    ../darwin/homebrew-shared.nix
    ../darwin/homebrew-work.nix
  ];

  home-manager.users.${user}.imports = [
    ../home/packages-shared.nix
    ../home/packages-work.nix
  ];
}
