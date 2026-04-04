# User-Pakete via Nix (CLI-Tools, nicht in Homebrew)
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hostmux    # SSH Multi-Host via Tmux
    nixfmt     # Nix Code Formatter
    pipx       # Python CLI Apps in isolierten Envs

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
