# Homebrew shared: Casks, Brews, Mac App Store - was auf ALLEN Hosts gilt.
# zap = entfernt nicht-deklarierte Pakete bei jedem Rebuild
{ lib, user, ... }:
{
  # Brew env-Tweaks gegen Corporate-Network-Probleme.
  # mkBefore = exports laufen im selben Shell-Kontext vor brew bundle.
  # - DOWNLOAD_CONCURRENCY=1: keine parallelen Downloads (Inspection-Proxy bricht sonst TLS ab)
  # - FORCE_BREWED_CURL=1: brew-eigene curl (OpenSSL) statt System-LibreSSL,
  #   handles corporate-proxy TLS-Quirks oft besser. Setzt voraus dass brew curl installiert ist.
  # - CURL_RETRIES=5: automatischer retry bei transient failures
  system.activationScripts.homebrew.text = lib.mkBefore ''
    export HOMEBREW_DOWNLOAD_CONCURRENCY=1
    export HOMEBREW_FORCE_BREWED_CURL=1
    export HOMEBREW_CURL_RETRIES=5
  '';

  homebrew = {
    enable = true;
    user = user;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # cleanup = "zap";
      cleanup = "none"; ## ZAP ist besser als uninstall, aber bugy in 06/2026
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
      "1password-cli"        # ehemals brew-formula, jetzt nur noch als cask
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
      "curl"            # brew-eigene curl mit OpenSSL (siehe HOMEBREW_FORCE_BREWED_CURL oben)
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
