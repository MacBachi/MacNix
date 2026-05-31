# Nix-Einstellungen, GC, Store-Optimierung, Firewall, sudo
{ pkgs, ... }:

let
  # Smart-GC: behaelt mind. die letzten minKeep System-Generations UND
  # alles juenger als maxAgeDays. Loescht nur was BEIDE: ausserhalb der
  # letzten minKeep UND aelter als maxAgeDays. Verhindert "renix nach Urlaub
  # = kein Rollback-Ziel mehr" (was mit dem alten --delete-older-than passieren konnte).
  minKeep = 2;
  maxAgeDays = 7;

  smartGc = pkgs.writeShellScript "nix-smart-gc" ''
    set -eu
    export PATH=${pkgs.nix}/bin:${pkgs.coreutils}/bin:${pkgs.gawk}/bin:$PATH

    PROFILE=/nix/var/nix/profiles/system
    NOW=$(date +%s)
    CUTOFF=$((NOW - ${toString maxAgeDays} * 86400))

    # Format: " ID   YYYY-MM-DD   HH:MM:SS   [(current)]"  (sortiert nach ID aufsteigend)
    GENS=$(nix-env --profile "$PROFILE" --list-generations | awk '{print $1, $2"T"$3}')
    TOTAL=$(printf '%s\n' "$GENS" | wc -l | tr -d ' ')

    if [ "$TOTAL" -le "${toString minKeep}" ]; then
      echo "[smart-gc] $TOTAL Generations vorhanden, nichts zu loeschen (Floor=${toString minKeep})"
    else
      # die juengsten minKeep ueberspringen (letzte Zeilen der nach ID sortierten Liste)
      CONSIDER=$(printf '%s\n' "$GENS" | head -n $((TOTAL - ${toString minKeep})))

      TO_DELETE=$(printf '%s\n' "$CONSIDER" | while read -r ID TS; do
        EPOCH=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$TS" +%s 2>/dev/null) || continue
        if [ "$EPOCH" -lt "$CUTOFF" ]; then
          echo "$ID"
        fi
      done)

      if [ -n "$TO_DELETE" ]; then
        echo "[smart-gc] loesche Generations: $TO_DELETE"
        nix-env --profile "$PROFILE" --delete-generations $TO_DELETE
      else
        echo "[smart-gc] keine Generation aelter als ${toString maxAgeDays}d ausserhalb der letzten ${toString minKeep}"
      fi
    fi

    # Store-Cleanup: loescht nur dereferenzierte Pfade, keine Generations
    nix-collect-garbage
  '';
in
{
  system.primaryUser = "mb";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    warn-dirty = false;
    max-jobs = "auto"; # alle CPU-Kerne fuer Builds nutzen
  };

  # Generation-GC: Sonntag 03:15 via custom smart-gc (siehe oben).
  # Default nix.gc deaktiviert weil --delete-older-than keinen "behalte mind. N" Floor kennt.
  nix.gc.automatic = false;

  launchd.daemons.nix-smart-gc = {
    command = "${smartGc}";
    serviceConfig = {
      StartCalendarInterval = [{
        Hour = 3;
        Minute = 15;
        Weekday = 7;
      }];
      StandardOutPath = "/var/log/nix-smart-gc.log";
      StandardErrorPath = "/var/log/nix-smart-gc.log";
    };
  };

  # Store-Optimierung: Sonntag 04:00, dedupliziert via Hardlinks
  nix.optimise = {
    automatic = true;
    interval = [
      {
        Hour = 4;
        Minute = 0;
        Weekday = 7;
      }
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Firewall: allowSigned=false blockiert auch signierte Apps (congress mode)
  networking.applicationFirewall = {
    enable = true;
    allowSigned = false;
    enableStealthMode = true;
  };

  system.stateVersion = 6;

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    watchIdAuth = true;
  };

}
