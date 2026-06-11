# Homebrew-Pakete die NUR auf privaten Hosts landen sollen.
# Wird nur von hosts/macos/per-host/{private-hosts}.nix importiert.
# EDR-Risiko bzw. corporate-policy-unfreundlich: gehoeren NICHT auf workmac.
{ ... }:
{
  homebrew.casks = [
    # Browser
    "brave-browser"

    # Kommunikation
    "zoom"

    # KI & Development
    "arduino-ide"
    "ngrok"             # tunneling - haeufig von corporate EDR geflaggt
    "podman-desktop"

    # Virtualisierung & Remote
    "rustdesk"
    "utm"

    # Sonstiges
    "ultimaker-cura"
    "mattermost"
  ];

  homebrew.brews = [
    # Container (corporate nutzt eigenes Container-Setup)
    "podman"
    "podman-compose"
    "podman-tui"

    # Offensive Security (von Defender/EDR sehr wahrscheinlich geblockt)
    "masscan"
    "nuclei"
    "rustscan"
  ];

  homebrew.masApps = {
    "Paperparrot" = 1663665267;
  };
}
