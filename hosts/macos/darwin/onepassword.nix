# 1Password Direkt-Install via 1Password CDN.
#
# Warum nicht via brew-cask: das Cask haengt regelmaessig versions-maessig hinter
# (lag uns am Hals weil lokale 1P-Daten neuer waren als das Cask installierte).
# Warum nicht via nixpkgs _1password-gui: hash-drift gegen die 1P CDN
# (Corporate Inspection-Proxies brachen das ausserdem ab).
#
# 1Password hat einen eigenen Auto-Updater - wir bringen nur die erste Version
# rein, danach aktualisiert sich die App selbst.
#
# Der eigentliche install-Code liegt in einem separaten writeShellScript damit
# Fehler dort nicht die ganze darwin-Aktivierung killen (das postActivation
# laeuft im gleichen shell-Prozess mit set -e).
{ pkgs, lib, ... }:
let
  install1Password = pkgs.writeShellScript "install-1password" ''
    set -u
    # bewusst KEIN set -e: wir wollen die activate nicht killen wenn der
    # download ausfaellt; stattdessen sauberer exit 0 mit warnung.

    TARGET="/Applications/1Password.app"
    URL="https://downloads.1password.com/mac/1Password.zip"
    TMP=$(mktemp -d)
    trap 'rm -rf "$TMP"' EXIT

    echo "[1password] checking CDN..." >&2
    if ! ${pkgs.curl}/bin/curl -fsSL --connect-timeout 10 --max-time 180 \
        -o "$TMP/1p.zip" "$URL"; then
      echo "[1password] WARN: CDN download fehlgeschlagen" >&2
      exit 0
    fi

    if ! ${pkgs.unzip}/bin/unzip -q "$TMP/1p.zip" -d "$TMP/extracted/"; then
      echo "[1password] WARN: unzip fehlgeschlagen" >&2
      exit 0
    fi

    # Finde echtes .pkg ODER 1Password.app das nicht der Installer-Wrapper ist.
    # while-read-loop statt grep|head Pipes wegen pipefail-Stolpern.
    APP=""
    PKG=""
    while IFS= read -r line; do
      case "$line" in
        *.pkg)
          PKG="$line"
          ;;
        */1Password.app)
          case "$line" in
            *Installer*) ;;
            *) APP="$line" ;;
          esac
          ;;
      esac
    done < <(/usr/bin/find "$TMP/extracted" -maxdepth 5 \
              \( -name "*.pkg" -o -name "1Password.app" \) 2>/dev/null)

    if /usr/bin/pgrep -x "1Password" >/dev/null 2>&1; then
      echo "[1password] 1Password laeuft - skip install" >&2
      exit 0
    fi

    OLD_VER=""
    if [ -f "$TARGET/Contents/Info.plist" ]; then
      OLD_VER=$(/usr/bin/plutil -extract CFBundleShortVersionString raw -o - \
                "$TARGET/Contents/Info.plist" 2>/dev/null || echo "")
    fi

    if [ -n "$PKG" ]; then
      if /usr/sbin/installer -pkg "$PKG" -target / >/dev/null 2>&1; then
        NEW_VER=$(/usr/bin/plutil -extract CFBundleShortVersionString raw -o - \
                  "$TARGET/Contents/Info.plist" 2>/dev/null || echo "?")
        echo "[1password] installed $NEW_VER via pkg (was: ''${OLD_VER:-none})" >&2
      else
        echo "[1password] WARN: pkg installer fehlgeschlagen" >&2
      fi
    elif [ -n "$APP" ]; then
      rm -rf "$TARGET"
      /bin/cp -R "$APP" "$TARGET"
      NEW_VER=$(/usr/bin/plutil -extract CFBundleShortVersionString raw -o - \
                "$TARGET/Contents/Info.plist" 2>/dev/null || echo "?")
      echo "[1password] installed $NEW_VER via app-copy (was: ''${OLD_VER:-none})" >&2
    else
      echo "[1password] WARN: weder .pkg noch echte 1Password.app im zip. tree:" >&2
      /usr/bin/find "$TMP/extracted" -maxdepth 3 >&2 2>/dev/null || true
    fi

    exit 0
  '';
in
{
  # Migration: 1Password aus brew untracken BEVOR brew bundle zap-Cleanup
  # laufen wuerde. Zap-Stanza wuerde User-Daten in ~/Library loeschen!
  system.activationScripts.homebrew.text = lib.mkBefore ''
    if [ -d "/opt/homebrew/Caskroom/1password" ]; then
      echo "[1password] untracking brew cask (Migration zu Direkt-Install)" >&2
      /opt/homebrew/bin/brew uninstall --cask 1password --force 2>/dev/null || true
    fi
  '';

  # Aufruf des isolierten install-Scripts mit '|| true' damit selbst wenn
  # darin alles in die Hose geht der activate-Lauf nicht abbricht.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    ${install1Password} || echo "[1password] install-script exited non-zero, weiter mit activate" >&2
  '';
}
