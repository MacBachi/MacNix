# ./darwin/homebrew.nix
{ ... }:
{
  # "inputs" wird nicht mehr gebraucht
  homebrew = {
    enable = true;
    user = "mb";
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    
    caskArgs = {
      no_quarantine = true;
    };
    casks = [
      "ngrok"
      "dockdoor"
      "claude"
      "microsoft-powerpoint"
      "microsoft-word"
      "microsoft-excel"
      "atuin-desktop"
      "alfred"
      "setapp"
      "signal"
      "nordvpn"
      "keyclu"
      "displaylink"
      "arduino-ide"
      "yubico-authenticator"
      "hazel"
      "ultimaker-cura"
      "uhk-agent"
      "little-snitch"
      "knockknock"
      "rustdesk"
      "chromium"
      "telegram"
      "launchos"
      "utm"
      "zoom"
    ];
    brews = [
      "gping"
      "magic-wormhole"
      "progress"
      "ripgrep"
      "ripgrep-all"
      "watch"
      "fping"
      "masscan"
      "nmap"
      "termshark"
      "prettyping"
      "mosh"
      "agg"
      "asciinema"
      "fortune"
      "mtr"
      "pv"
      "rlwrap"
      "wget"
      "tree"
      "arping"
      "atuin"
      "lynis"
      "gnupg"
      "colordiff"
      "cowsay"
      "mc"
      "lolcat"
      "age"
      "sops"
      "procs"
      "btop"
      "broot"
      "httpie"
      "icdiff"
      "duf"
      "dust"
      "fd"
      "glances"
      "jq"
      "autojump"
      "gh"
      "aria2"
      "chroma"
      "z.lua"
      "zellij"
      "nushell"
      "lftp"
      "starship"
      "ranger"
      "fabric-ai"
      "ollama"
      "gocheat"
      "cheat"
      "bottom"                 # bottom - top/htop replacement
      "piknik"                 # Ausgabe eines Befehls schnell als Gist oder in einer Pastebin-Instanz speichern
      "ripgrep"
      "croc"                   # Tool für die plattformübergreifende Dateiübertragung
      "tealdeer"               # alternative zu tldr
      "zoxide"
      "rustscan"
      "nuclei"
      "ncdu"
      "dug"
      "mas"
      "httping"
      "nethogs"
      "hugo"
      "no-more-secrets"         # Recreates the SETEC ASTRONOMY effect from 'Sneakers'
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "Paperparrot" = 1663665267;
      "Wireguard" = 1451685025;
      "Actions for Obsidian" = 1659667937;
      "uBlock Origin Lite" = 6745342698;
      "Vinegar" = 1591303229;
      "1Blocker" = 1365531024;
      "Goodnotes: KI-Notizen, PDF" = 1444383602;
      "Googly Eyes" = 6743048714;
    };
  };
}
