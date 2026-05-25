#!/usr/bin/env bash
# firefox-discover: inspiziere live-firefox-profil
#
# nutzung: bash hosts/macos/home/firefox-discover.sh
# zweck:   drift-check vor/nach renix
# schreibt nichts auf disk - keine secrets im output

set -euo pipefail

FF_DIR="$HOME/Library/Application Support/Firefox"
INI="$FF_DIR/profiles.ini"

if [ ! -f "$INI" ]; then
  echo "❌ profiles.ini fehlt - firefox noch nicht initialisiert" >&2
  exit 1
fi

# default-profil ermitteln (gleiche logik wie activation-script)
DEFAULT=$(awk -F= '
  /^\[Install/ { in_install=1; next }
  /^\[/        { in_install=0 }
  in_install && $1=="Default" { print $2; exit }
' "$INI")

if [ -z "$DEFAULT" ]; then
  DEFAULT=$(awk -F= '
    BEGIN { p=""; d=0; in_p=0 }
    /^\[Profile/ { p=""; d=0; in_p=1; next }
    /^\[/        { if(in_p && d==1) { print p; exit } ; in_p=0 }
    in_p && $1=="Path"    { p=$2 }
    in_p && $1=="Default" && $2==1 { d=1 }
    END { if(in_p && d==1) print p }
  ' "$INI")
fi

if [ -z "$DEFAULT" ]; then
  echo "❌ kein default-profil in profiles.ini erkannt" >&2
  exit 1
fi

PROFILE="$FF_DIR/$DEFAULT"
echo "🖥️  hostname:        $(hostname -s)"
echo "📂 default profile: $PROFILE"
echo ""

# nix-managed files: symlink-status
echo "═══ nix-managed files ═══"
for f in "user.js" "chrome/userChrome.css"; do
  full="$PROFILE/$f"
  if [ -L "$full" ]; then
    echo "✅ $f -> $(readlink "$full")"
  elif [ -f "$full" ]; then
    echo "⚠️  $f existiert, aber kein symlink (noch nicht nix-managed)"
  else
    echo "○ $f nicht vorhanden (renix legt es an)"
  fi
done
echo ""

# aktive custom prefs (gefiltert auf hardening-keys)
echo "═══ aktive custom prefs (gefiltert) ═══"
prefs_file="$PROFILE/prefs.js"
filter='telemetry|tracking|trr|https_only|webrender|pocket|normandy|discovery|sponsored|activity-stream|punycode|send_pings|beacon|peerconnection|firstparty|cookieBehavior|formfill|breach|devtools\.|aboutConfig|sessionstore|loadDivertedInBackground|unloadOnLowMemory|enableScripting|globalprivacycontrol|donottrack|urlbar\.(trim|suggest|weather)|hardware-video-decoding'
if [ -f "$prefs_file" ]; then
  matched=$(grep '^user_pref' "$prefs_file" | grep -E "$filter" || true)
  if [ -n "$matched" ]; then
    echo "$matched" | head -30
    total=$(echo "$matched" | wc -l | tr -d ' ')
    [ "$total" -gt 30 ] && echo "... ($total zeilen gesamt, gekuerzt)"
  else
    echo "(keine matching prefs - profil noch nicht gehaertet)"
  fi
else
  echo "(prefs.js nicht vorhanden)"
fi
echo ""

# installierte extensions
echo "═══ installed extensions ═══"
ext_file="$PROFILE/extensions.json"
if [ -f "$ext_file" ] && command -v jq >/dev/null 2>&1; then
  jq -r '
    .addons[]
    | select(.location=="app-profile" and .type=="extension")
    | "  \(.defaultLocale.name // "?")  →  \(.id)"
  ' "$ext_file" 2>/dev/null || echo "(jq-parse-fehler)"
elif [ -f "$ext_file" ]; then
  echo "(jq fehlt)"
else
  echo "(extensions.json nicht vorhanden)"
fi
echo ""

# sidebery check via extension-id
echo "═══ sidebery ═══"
sidebery_id="{3c078156-979c-498b-8990-85f7987dd929}"
if [ -f "$ext_file" ] && command -v jq >/dev/null 2>&1 && \
   jq -e --arg id "$sidebery_id" '.addons[] | select(.id==$id)' "$ext_file" >/dev/null 2>&1; then
  echo "✅ installiert"
  echo "   marker pruefen: sidebery-ui -> settings -> appearance ->"
  echo "                   'set window title preface' = [✂️]"
else
  echo "⚠️  nicht installiert"
  echo "   1. addons.mozilla.org/firefox/addon/sidebery/"
  echo "   2. settings -> appearance -> 'set window title preface' = [✂️]"
  echo "   3. 'apply title preface when sidebar is open' anhaken"
fi
