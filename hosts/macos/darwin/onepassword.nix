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
# postActivation weil nix-darwin nur feste Activation-Slots kennt
# (preActivation, users, groups, applications, homebrew, postActivation, ...).
# Eigene Keys wie "onePassword" werden nicht in den activate-Script eingebaut.
{ pkgs, lib, ... }:
{
  system.activationScripts.postActivation.text = lib.mkAfter ''
    TARGET="/Applications/1Password.app"
    URL="https://downloads.1password.com/mac/1Password.zip"

    # Trigger: dir fehlt ODER op-ssh-sign binary fehlt (broken symlink, partial install)
    if [ ! -d "$TARGET" ] || [ ! -x "$TARGET/Contents/MacOS/op-ssh-sign" ]; then
      echo "[1password] direct-install von 1Password CDN" >&2
      TMP=$(mktemp -d)
      if ${pkgs.curl}/bin/curl -fsSL -o "$TMP/1p.zip" "$URL"; then
        # broken symlink / alte Installation wegraeumen
        rm -rf "$TARGET"
        ${pkgs.unzip}/bin/unzip -q "$TMP/1p.zip" -d /Applications/
        echo "[1password] installed at $TARGET" >&2
      else
        echo "[1password] WARN: download fehlgeschlagen, lasse vorhandenen Stand" >&2
      fi
      rm -rf "$TMP"
    fi
  '';
}
