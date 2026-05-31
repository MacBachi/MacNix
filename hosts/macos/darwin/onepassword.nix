# 1Password Direkt-Install via 1Password CDN.
#
# Warum nicht via brew-cask: das Cask haengt regelmaessig versions-maessig hinter
# (lag uns am Hals weil lokale 1P-Daten neuer waren als das Cask installierte).
# Warum nicht via nixpkgs _1password-gui: hash-drift gegen die 1P CDN
# (Corporate Inspection-Proxies brachen das ausserdem ab).
#
# 1Password hat einen eigenen Auto-Updater - wir bringen nur die erste Version
# rein, danach aktualisiert sich die App selbst. --time-cond sorgt dafuer dass
# wir nur runterladen wenn CDN tatsaechlich neuer als unsere lokale Version ist.
{ pkgs, lib, ... }:
{
  # Migration: 1Password aus brew untracken BEVOR brew bundle zap-Cleanup
  # laufen wuerde. Zap-Stanza wuerde User-Daten in ~/Library loeschen!
  # mkBefore = laeuft im selben Shell-Kontext vor dem nix-darwin homebrew Block.
  system.activationScripts.homebrew.text = lib.mkBefore ''
    if [ -d "/opt/homebrew/Caskroom/1password" ]; then
      echo "[1password] untracking brew cask (Migration zu Direkt-Install)" >&2
      /opt/homebrew/bin/brew uninstall --cask 1password --force 2>/dev/null || true
    fi
  '';

  # Direkt-Install vom 1Password CDN. Laeuft auf jedem renix:
  # 1) immer runterladen (~150MB),
  # 2) Bundle-Version vergleichen via Info.plist,
  # 3) nur ersetzen wenn unterschiedlich UND App nicht laeuft.
  # Kein --time-cond mehr - das vergleicht mtime gegen Last-Modified, beide
  # spiegeln aber nicht den Inhalts-Versions-Stand wider (brew kann eine alte
  # Version mit "heute" mtime installieren).
  system.activationScripts.postActivation.text = lib.mkAfter ''
    TARGET="/Applications/1Password.app"
    URL="https://downloads.1password.com/mac/1Password.zip"
    TMP=$(mktemp -d)
    trap 'rm -rf "$TMP"' EXIT

    echo "[1password] checking CDN..." >&2
    if ${pkgs.curl}/bin/curl -fsSL -o "$TMP/1p.zip" "$URL"; then
      ${pkgs.unzip}/bin/unzip -q "$TMP/1p.zip" -d "$TMP/extracted/"

      NEW_VER=$(/usr/bin/plutil -extract CFBundleShortVersionString raw "$TMP/extracted/1Password.app/Contents/Info.plist" 2>/dev/null || echo "")
      OLD_VER=$(/usr/bin/plutil -extract CFBundleShortVersionString raw "$TARGET/Contents/Info.plist" 2>/dev/null || echo "")

      if [ -n "$NEW_VER" ] && [ "$NEW_VER" != "$OLD_VER" ]; then
        if /usr/bin/pgrep -x "1Password" >/dev/null; then
          echo "[1password] version differs (have:''${OLD_VER:-none} want:$NEW_VER) but 1Password is running. Quit it and rerun renix to upgrade." >&2
        else
          rm -rf "$TARGET"
          mv "$TMP/extracted/1Password.app" "$TARGET"
          echo "[1password] installed $NEW_VER (was: ''${OLD_VER:-none})" >&2
        fi
      else
        echo "[1password] already at $NEW_VER" >&2
      fi
    else
      echo "[1password] WARN: CDN download failed" >&2
    fi
  '';
}
