# 1Password Erst-Install via 1Password CDN.
#
# Bewusst minimal: wenn die App schon da ist, machen wir nichts. 1Password
# hat einen eigenen Auto-Updater - die kuemmert sich um Versions-Updates,
# nicht wir. Dadurch entfaellt der ganze Versions-Vergleich, pgrep, etc.
#
# Brew-cask-Migration bleibt drin: vorhandene brew-Installation untracken
# bevor brew bundle zap die User-Daten in ~/Library mit loescht.
{ pkgs, lib, ... }:
let
  install1Password = pkgs.writeShellScript "install-1password" ''
    set -u

    TARGET="/Applications/1Password.app"

    # Schon da? Nichts tun. 1Password's eigener Updater uebernimmt.
    if [ -d "$TARGET" ]; then
      exit 0
    fi

    URL="https://downloads.1password.com/mac/1Password.zip"
    TMP=$(mktemp -d)
    trap 'rm -rf "$TMP"' EXIT

    echo "[1password] target fehlt, lade von CDN" >&2
    if ! ${pkgs.curl}/bin/curl -fsSL --connect-timeout 10 --max-time 180 \
        -o "$TMP/1p.zip" "$URL"; then
      echo "[1password] WARN: CDN download fehlgeschlagen" >&2
      exit 0
    fi

    if ! ${pkgs.unzip}/bin/unzip -q "$TMP/1p.zip" -d "$TMP/extracted/"; then
      echo "[1password] WARN: unzip fehlgeschlagen" >&2
      exit 0
    fi

    # Suche .pkg ODER echte 1Password.app (nicht Installer-Wrapper) im zip
    PKG=$(/usr/bin/find "$TMP/extracted" -maxdepth 5 -name "*.pkg" 2>/dev/null | /usr/bin/head -1)
    APP=""
    while IFS= read -r l; do
      case "$l" in
        *Installer*) ;;
        *) APP="$l"; break ;;
      esac
    done < <(/usr/bin/find "$TMP/extracted" -maxdepth 5 -type d -name "1Password.app" 2>/dev/null)

    if [ -n "$PKG" ]; then
      if /usr/sbin/installer -pkg "$PKG" -target / >/dev/null 2>&1; then
        echo "[1password] installed via pkg" >&2
      else
        echo "[1password] WARN: pkg installer fehlgeschlagen" >&2
      fi
    elif [ -n "$APP" ]; then
      if /bin/cp -R "$APP" "$TARGET"; then
        echo "[1password] installed via app-copy" >&2
      else
        echo "[1password] WARN: app-copy fehlgeschlagen" >&2
      fi
    else
      echo "[1password] WARN: weder pkg noch echte app im zip" >&2
    fi

    exit 0
  '';
in
{
  # Brew-cask-Migration vor brew bundle: vorhandenen 1password-Cask
  # untracken bevor bundle's zap die User-Daten in ~/Library mit loescht.
  system.activationScripts.homebrew.text = lib.mkBefore ''
    if [ -d "/opt/homebrew/Caskroom/1password" ]; then
      echo "[1password] untracking brew cask (Migration zu Direkt-Install)" >&2
      /opt/homebrew/bin/brew uninstall --cask 1password --force 2>/dev/null || true
    fi
  '';

  system.activationScripts.postActivation.text = lib.mkAfter ''
    ${install1Password} || echo "[1password] install-script exited non-zero" >&2
  '';
}
