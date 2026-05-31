# per-Host Overlay: PN1030UZ2568748 (workmac, aarch64)
# Importiert shared + work (NICHT private). Tools die nur auf privaten Macs
# Sinn machen werden in Phase 3b aus shared nach private verschoben.
{ user, lib, ... }:
{
  imports = [
    ../darwin/homebrew-shared.nix
    ../darwin/homebrew-work.nix
  ];

  home-manager.users.${user}.imports = [
    ../home/packages-shared.nix
    ../home/packages-work.nix
  ];

  # Dock: Edge direkt nach Firefox (workmac-spezifisch, sonst identisch zur
  # shared-Liste in darwin/macos.nix). mkForce weil persistent-apps ein
  # Listen-Option ist und sonst konkateniert wuerde.
  system.defaults.dock.persistent-apps = lib.mkForce [
    "/Applications/Setapp/Path Finder.app"
    "/Applications/Safari.app"
    "/Applications/Firefox.app"
    "/Applications/Microsoft Edge.app"
    "/System/Applications/Messages.app"
    "/Applications/Nix Apps/Wave.app"
    "/Applications/1Password.app"
    "/System/Applications/Mail.app"
    "/Applications/Nix Apps/Obsidian.app"
    "/Applications/Setapp/Numi.app"
    "/Applications/Signal.app"
  ];
}
