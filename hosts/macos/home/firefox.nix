# firefox: deklarative profile-config via home.activation
#
# - kein hardcoded profile-path, kein per-host mapping
# - findet das default-profil dynamisch via profiles.ini
# - graceful skip wenn firefox noch nicht initialisiert (frische installation)
# - idempotent: kann beliebig oft laufen
#
# bewusst nicht inkludiert (potenzielle secrets / persoenlich):
#   bookmarks, history, logins, cookies, sync-account-daten,
#   sidebery-tab-state, container-tab-configs
#
# einmaliger manueller schritt (nicht via nix automatisierbar):
#   sidebery installieren -> settings -> appearance -> "set window title preface" = [✂️]
#   "apply title preface when sidebar is open" anhaken

{ config, lib, pkgs, ... }:

let
  cat = config.theme.catppuccin-mocha;

  # marker den sidebery in den fenstertitel schreibt wenn sidebar offen
  sideberyMarker = "[✂️]";

  # === user.js (about:config-prefs) ===========================================
  # konservativ: alles hier ist ohne nachteil oder mit gut kalkulierbarem trade-off.
  # KEINE settings die ganze klassen von websites brechen.
  userJs = pkgs.writeText "firefox-user.js" ''
    // generiert von nix - manuelle edits werden ueberschrieben

    // telemetrie / studies / discovery
    user_pref("toolkit.telemetry.enabled", false);
    user_pref("toolkit.telemetry.unified", false);
    user_pref("toolkit.telemetry.archive.enabled", false);
    user_pref("toolkit.telemetry.bhrPing.enabled", false);
    user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
    user_pref("toolkit.telemetry.newProfilePing.enabled", false);
    user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
    user_pref("toolkit.telemetry.updatePing.enabled", false);
    user_pref("datareporting.healthreport.uploadEnabled", false);
    user_pref("datareporting.policy.dataSubmissionEnabled", false);
    user_pref("app.shield.optoutstudies.enabled", false);
    user_pref("app.normandy.enabled", false);
    user_pref("browser.discovery.enabled", false);
    user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);

    // new-tab-page cleanup
    user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
    user_pref("browser.newtabpage.activity-stream.showSponsored", false);
    user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
    user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
    user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
    user_pref("extensions.pocket.enabled", false);

    // anti-tracking (safe)
    user_pref("privacy.trackingprotection.enabled", true);
    user_pref("privacy.trackingprotection.socialtracking.enabled", true);
    user_pref("privacy.donottrackheader.enabled", true);
    user_pref("privacy.globalprivacycontrol.enabled", true);
    user_pref("browser.send_pings", false);
    user_pref("beacon.enabled", false);

    // anti-phishing: idn als punycode anzeigen
    user_pref("network.IDN_show_punycode", true);

    // https-only-mode
    user_pref("dom.security.https_only_mode", true);

    // dns-over-https (quad9, mit system-fallback)
    // mode 2 = trr mit fallback (captive-portal-freundlich). mode 3 waere strikt.
    user_pref("network.trr.mode", 2);
    user_pref("network.trr.uri", "https://dns.quad9.net/dns-query");
    user_pref("network.trr.bootstrapAddress", "9.9.9.9");

    // url-bar hygiene
    user_pref("browser.urlbar.trimURLs", false);
    user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
    user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
    user_pref("browser.urlbar.weather.featureGate", false);
    user_pref("browser.urlbar.suggest.topsites", false);

    // tab-management
    user_pref("browser.tabs.loadDivertedInBackground", true);
    user_pref("browser.sessionstore.max_tabs_undo", 50);
    user_pref("browser.sessionstore.max_windows_undo", 10);
    user_pref("browser.tabs.unloadOnLowMemory", true);

    // form-autocomplete-history aus (login-manager bleibt unberuehrt)
    user_pref("browser.formfill.enable", false);

    // security
    user_pref("pdfjs.enableScripting", false);
    user_pref("signon.management.page.breach-alerts.enabled", true);

    // devtools (essentiell fuer userscript-dev)
    user_pref("devtools.chrome.enabled", true);
    user_pref("devtools.debugger.remote-enabled", true);
    user_pref("devtools.styleeditor.autocompletion-enabled", true);

    // ui-annoyances
    user_pref("browser.aboutConfig.showWarning", false);

    // performance
    user_pref("media.hardware-video-decoding.force-enabled", true);
    user_pref("gfx.webrender.all", true);

    // ---------------------------------------------------------------------------
    // optional / aggressiver - bei bedarf entkommentieren:
    // ---------------------------------------------------------------------------
    // user_pref("privacy.firstparty.isolate", true);             // bricht viele sso-flows
    // user_pref("network.cookie.cookieBehavior", 5);             // total cookie protection
    // user_pref("media.peerconnection.enabled", false);          // bricht jitsi/meet/discord
    // user_pref("browser.search.suggest.enabled", false);        // keine live-suggestions
    // user_pref("browser.tabs.closeWindowWithLastTab", false);   // cmd+w am letzten tab
    // user_pref("browser.ctrlTab.sortByRecentlyUsed", true);     // mru-cycling
  '';

  # === userChrome.css =========================================================
  # farben aus theme.nix (catppuccin mocha) - keine hardcoded hexcodes hier.
  userChromeCss = pkgs.writeText "firefox-userChrome.css" ''
    /* url-bar - direkt aufs container-element, innere transparent */
    #urlbar {
      background: ${cat.surface0} !important;
      border: 2px solid ${cat.blue} !important;
      border-radius: 6px !important;
    }

    #urlbar-background,
    #urlbar-input-container {
      background: transparent !important;
    }

    #urlbar[focused="true"] {
      background: ${cat.surface1} !important;
      box-shadow: 0 0 0 4px ${cat.blue}80 !important;
    }

    #urlbar-input {
      color: ${cat.text} !important;
    }

    /* aktiver tab - gradient + akzent */
    .tabbrowser-tab[selected="true"] {
      background: linear-gradient(to bottom, ${cat.surface1}, ${cat.base}) !important;
      border-top: 2px solid ${cat.blue} !important;
    }

    /* sidebery offen -> tab-leiste oben ausblenden
       (sidebery schreibt "${sideberyMarker}" als title-preface, firefox spiegelt
       in titlepreface-attribut auf #main-window) */
    #main-window[titlepreface*="${sideberyMarker}"] #TabsToolbar {
      visibility: collapse !important;
    }
    #main-window[titlepreface*="${sideberyMarker}"] :root {
      --tab-min-height: 0 !important;
    }
    #main-window[titlepreface*="${sideberyMarker}"] #navigator-toolbox {
      padding-top: 0 !important;
    }
  '';
in
{
  # findet default-profil dynamisch, verlinkt user.js + userChrome.css.
  # warnung: ueberschreibt eine vorhandene userChrome.css beim ersten renix.
  home.activation.firefoxConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    set -eu
    FF_DIR="$HOME/Library/Application Support/Firefox"
    INI="$FF_DIR/profiles.ini"

    # neuinstallation: firefox noch nicht initialisiert
    if [ ! -f "$INI" ]; then
      echo "[firefox] profiles.ini fehlt - firefox einmal starten, dann renix"
      exit 0
    fi

    # default-profil via profiles.ini
    # strategie 1: [Install*] -> Default=<path>  (firefox 67+)
    DEFAULT=$(${pkgs.gawk}/bin/awk -F= '
      /^\[Install/ { in_install=1; next }
      /^\[/        { in_install=0 }
      in_install && $1=="Default" { print $2; exit }
    ' "$INI")

    # strategie 2: [Profile*] mit Default=1  (legacy fallback)
    if [ -z "$DEFAULT" ]; then
      DEFAULT=$(${pkgs.gawk}/bin/awk -F= '
        BEGIN { p=""; d=0; in_p=0 }
        /^\[Profile/ { p=""; d=0; in_p=1; next }
        /^\[/        { if(in_p && d==1) { print p; exit } ; in_p=0 }
        in_p && $1=="Path"    { p=$2 }
        in_p && $1=="Default" && $2==1 { d=1 }
        END { if(in_p && d==1) print p }
      ' "$INI")
    fi

    if [ -z "$DEFAULT" ]; then
      echo "[firefox] kein default-profil erkannt - skip"
      exit 0
    fi

    PROFILE="$FF_DIR/$DEFAULT"
    $DRY_RUN_CMD mkdir -p "$PROFILE/chrome"
    $DRY_RUN_CMD ln -sfn ${userJs}         "$PROFILE/user.js"
    $DRY_RUN_CMD ln -sfn ${userChromeCss}  "$PROFILE/chrome/userChrome.css"
    echo "[firefox] verlinkt nach $PROFILE"
  '';
}
