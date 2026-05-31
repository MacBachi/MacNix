# Homebrew-Pakete die NUR auf dem work-Host landen sollen.
# Wird nur von hosts/macos/per-host/{work-hosts}.nix importiert.
# MS-Suite: Word/Excel/PowerPoint stehen in shared (gibt's auch privat).
# Hier nur die work-zusaetzlichen Office-Apps.
# Keine Bundle-Casks (microsoft-office) wegen Konflikt mit den Einzel-Casks in shared.
{ ... }:
{
  homebrew.casks = [
    "microsoft-outlook"
    "microsoft-onenote"
    "microsoft-teams"
    "microsoft-auto-update"   # Lizenz-Pflicht fuer Office
  ];
}
