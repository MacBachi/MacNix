# Homebrew shared: Casks, Brews, Mac App Store - was auf ALLEN Hosts gilt.
# zap = entfernt nicht-deklarierte Pakete bei jedem Rebuild
{ lib, user, ... }:
{
  # Sequenzielle Downloads (statt brew's default parallel).
  # Grund: Corporate Inspection-Proxies (z.B. Defender for Endpoint) brechen
  # parallele TLS-Streams bei grossen Cask-Downloads mit bad-decrypt Fehler ab.
  # mkBefore = der Export laeuft vor dem nix-darwin homebrew Activation-Script,
  # alle Scripte teilen sich denselben Shell-Prozess.
  system.activationScripts.homebrew.text = lib.mkBefore ''
    export HOMEBREW_DOWNLOAD_CONCURRENCY=1
  '';

  homebrew = {
    enable = true;
    user = user;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    casks = [
      # Browser
      "firefox"

      # Kommunikation
      "signal"
      "telegram"

      # Produktivitaet
      "alfred"
      "setapp"
      "hazel"
      "dockdoor"
      "keyclu"
      "launchos"
      "microsoft-excel"
      "microsoft-word"
      "microsoft-powerpoint"

      # KI & Development
      "claude"
      "claude-code"

      # Virtualisierung & Remote
      "displaylink"

      # Security & VPN
      "little-snitch"
      "knockknock"
      "nordvpn"
      "yubico-authenticator"
      # 1password: direct-install via darwin/onepassword.nix (Cask haengt versionsmaessig hinter)
    ];

    brews = [
      # Netzwerk & Security
      "arping"
      "fping"
      "gping"
      "httping"
      "lynis"
      "mosh"
      "mtr"
      "nethogs"
      "nmap"
      "prettyping"
      "termshark"

      # Dateien & Suche
      "aria2"
      "eza"
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
      "viddy"

      # Shell & Navigation
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

      # Secrets & Crypto
      "age"
      "gnupg"
      "sops"
      "1password-cli"

      # Text, Diff & JSON
      "bat"
      "cheat"
      "chroma"
      "colordiff"
      "glow"
      "httpie"
      "icdiff"
      "jq"

      # Dateitransfer
      "croc"
      "magic-wormhole"
      "piknik"

      # Fun
      "chafa"
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

    masApps = {
      "1Blocker" = 1365531024;
      "1Password for Safari" = 1569813296;
      "Actions for Obsidian" = 1659667937;
      "Googly Eyes" = 6743048714;
      "Kagi for Safari" = 1622835804;
      "uBlock Origin Lite" = 6745342698;
      "Vinegar" = 1591303229;
      "Wireguard" = 1451685025;
    };
  };
}
