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
    ];
    brews = [
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
      "Goodnotes" = 1444383602;
    };
  };
}
