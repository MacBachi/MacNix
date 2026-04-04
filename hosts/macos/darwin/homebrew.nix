# ./darwin/homebrew.nix
{ ... }:
{
  homebrew = {
    enable = true;
    user = "mb";
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    # --- GUI Apps (Casks) ---
    casks = [
      # Browser
      "orion"

      # Kommunikation
      "signal"
      "telegram"
      "zoom"

      # Produktivitaet
      "alfred"
      "setapp"
      "hazel"
      "dockdoor"
      "keyclu"
      "launchos"
      "microsoft-excel"
      "microsoft-word"

      # KI & Development
      "claude"
      "claude-code"
      "arduino-ide"
      "ngrok"
      "podman-desktop"

      # Virtualisierung & Remote
      "rustdesk"
      "utm"
      "displaylink"

      # Security & VPN
      "little-snitch"
      "knockknock"
      "nordvpn"
      "yubico-authenticator"

      # Sonstiges
      "atuin-desktop"
      "ultimaker-cura"
    ];

    # --- CLI Tools (Brews) ---
    brews = [
      # Container & Virtualisierung
      "podman"
      "podman-compose"
      "podman-tui"

      # Netzwerk & Security
      "arping"
      "fping"
      "gping"
      "httping"
      "lynis"
      "masscan"
      "mosh"
      "mtr"
      "nethogs"
      "nmap"
      "nuclei"
      "prettyping"
      "rustscan"
      "termshark"

      # Dateien & Suche
      "aria2"
      "fd"
      "lftp"
      "ncdu"
      "ripgrep"
      "ripgrep-all"
      "wget"

      # System-Monitoring
      "bottom"
      "btop"
      "broot"
      "duf"
      "dust"
      "glances"
      "procs"
      "pv"
      "progress"

      # Shell & Navigation
      "atuin"
      "nushell"
      "ranger"
      "zellij"
      "zoxide"

      # Development
      "gh"
      "golang"
      "hugo"
      "tree-sitter"
      "tree-sitter-cli"

      # Verschluesselung & Secrets
      "age"
      "gnupg"
      "sops"

      # Text, Diff & JSON
      "cheat"
      "chroma"
      "colordiff"
      "httpie"
      "icdiff"
      "jq"

      # Dateitransfer
      "croc"
      "magic-wormhole"
      "piknik"

      # CLI Fun
      "cowsay"
      "fortune"
      "lolcat"
      "no-more-secrets"

      # Sonstiges
      "agg"
      "asciinema"
      "dug"
      "fabric-ai"
      "mas"
      "mc"
      "ollama"
      "rlwrap"
      "tree"
      "watch"
    ];

    # --- Mac App Store ---
    masApps = {
      "1Blocker" = 1365531024;
      "1Password for Safari" = 1569813296;
      "Actions for Obsidian" = 1659667937;
      "Googly Eyes" = 6743048714;
      "Kagi for Safari" = 1622835804;
      "Paperparrot" = 1663665267;
      "uBlock Origin Lite" = 6745342698;
      "Vinegar" = 1591303229;
      "Wireguard" = 1451685025;
    };
  };
}
