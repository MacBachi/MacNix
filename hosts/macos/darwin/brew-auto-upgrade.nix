# Taeglicher brew-Upgrade-Lauf (12:40) zwischen renix-Manuell-Runs.
# Laeuft als User (launchd.user.agents) - kein sudo noetig.
# Nutzt dieselben HOMEBREW_*-Env-Vars wie die Aktivierung (sonst stolpert
# workmac ueber den Corporate Inspection-Proxy).
{ pkgs, ... }:
let
  brewUpgrade = pkgs.writeShellScript "brew-auto-upgrade" ''
    set -u
    export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
    export HOMEBREW_DOWNLOAD_CONCURRENCY=1
    export HOMEBREW_FORCE_BREWED_CURL=1
    export HOMEBREW_CURL_RETRIES=5

    LOG_DIR="$HOME/.local/state/mynix/logs"
    mkdir -p "$LOG_DIR"
    LOG="$LOG_DIR/brew-upgrade.log"

    {
      echo ""
      echo "===== $(date '+%Y-%m-%dT%H:%M:%S%z') brew-auto-upgrade start ====="
      brew update
      brew upgrade
      brew cleanup --prune=7
      echo "===== $(date '+%Y-%m-%dT%H:%M:%S%z') brew-auto-upgrade done ====="
    } >> "$LOG" 2>&1
  '';
in
{
  launchd.user.agents.brew-auto-upgrade = {
    command = "${brewUpgrade}";
    serviceConfig = {
      StartCalendarInterval = [{
        Hour = 12;
        Minute = 40;
      }];
      RunAtLoad = false;
    };
  };
}
