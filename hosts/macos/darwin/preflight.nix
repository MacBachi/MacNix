# Hinweise auf Dinge die nicht via nix verwaltet werden.
# Aktuell nur 1Password (zu komplex/fragil ueber nix, eigener Auto-Updater
# uebernimmt nach Erst-Installation).
{ lib, ... }:
{
  system.activationScripts.postActivation.text = lib.mkAfter ''
    if [ ! -d "/Applications/1Password.app" ]; then
      printf '\033[1;31m' >&2
      echo "" >&2
      echo "================================================================" >&2
      echo "  1Password.app fehlt unter /Applications" >&2
      echo "" >&2
      echo "  Manuell installieren von:" >&2
      echo "    https://1password.com/downloads/mac" >&2
      echo "" >&2
      echo "  (bewusst nicht ueber nix - CDN-Versionsdrift, hash-mismatches" >&2
      echo "   und brew-cask-stale haben das in der Praxis nicht stabil" >&2
      echo "   hingekriegt. 1Password aktualisiert sich selbst.)" >&2
      echo "================================================================" >&2
      printf '\033[0m\n' >&2
    fi
  '';
}
