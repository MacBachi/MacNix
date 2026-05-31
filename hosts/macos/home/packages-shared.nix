# User-Pakete via Nix (CLI-Tools, nicht in Homebrew)
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hostmux    # SSH Multi-Host via Tmux
    nixfmt     # Nix Code Formatter
    # pipx: tests in test_package_specifier.py failen aktuell in nixpkgs-unstable
    # (whitespace-mismatch im packaging output). doCheck=false bis nixpkgs gefixt.
    (pipx.overrideAttrs (_: { doCheck = false; doInstallCheck = false; }))

    # CLI
    tldr       # Kurzanleitungen fuer CLI-Tools
    unp        # Universeller Entpacker
    w3m        # Text-Browser
    watchexec  # Datei-Watcher, fuehrt Befehle bei Aenderung aus
    sd         # Schneller sed-Ersatz

    # Netzwerk
    cloudflared   # Cloudflare Tunnel CLI
    iproute2mac   # Linux iproute2-Befehle fuer macOS
    links2        # Text-Browser mit optionalem Grafikmodus
  ];
}
