# Homebrew-Pakete die NUR auf dem work-Host landen sollen.
# Wird nur von hosts/macos/per-host/{work-hosts}.nix importiert.
{ ... }:
{
  homebrew.casks = [
    # MS-Suite (Intune pushed das NICHT - muss ueber brew kommen)
    "microsoft-office"          # Bundle: Word, Excel, PowerPoint, Outlook, OneNote
    "microsoft-teams"
    "microsoft-auto-update"     # Lizenz-Pflicht fuer Office
  ];
}
