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
  # --time-cond gegen die lokale Info.plist sorgt dafuer dass curl nur dann
  # tatsaechlich Daten zieht wenn remote neuer ist (sonst HTTP 304, leere Datei,
  # kein Update). 1Password's eigener Auto-Updater erhoeht die mtime wenn er
  # in-place updated, also harmonieren beide Wege.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    TARGET="/Applications/1Password.app"
    URL="https://downloads.1password.com/mac/1Password.zip"
    TMP=$(mktemp -d)
    trap 'rm -rf "$TMP"' EXIT

    REF="$TARGET/Contents/Info.plist"
    TIMECOND_ARGS=()
    if [ -f "$REF" ]; then
      TIMECOND_ARGS=(--time-cond "$REF")
    fi

    if ${pkgs.curl}/bin/curl -sSL "''${TIMECOND_ARGS[@]}" -o "$TMP/1p.zip" "$URL" \
       && [ -s "$TMP/1p.zip" ]; then
      echo "[1password] downloading fresh from 1Password CDN" >&2
      ${pkgs.unzip}/bin/unzip -q "$TMP/1p.zip" -d "$TMP/extracted/"
      rm -rf "$TARGET"
      mv "$TMP/extracted/1Password.app" "$TARGET"
      echo "[1password] installed at $TARGET" >&2
    else
      echo "[1password] keine neue Version (oder Download nicht moeglich)" >&2
    fi
  '';
}
