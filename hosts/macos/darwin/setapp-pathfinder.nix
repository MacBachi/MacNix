{
  config,
  pkgs,
  lib,
  ...
}:

let
  # 1. Den erwarteten Pfad zur Setapp-Version definieren
  pathFinderSetappPath = "/Applications/Setapp/Path Finder.app";

  # 2. Prüfen, ob die App existiert (Boolean)
  isPathFinderSetappInstalled = lib.pathExists pathFinderSetappPath;

in
{
  # ... andere Konfiguration ...

  # Einstellungsblock nur bei vorhandener App auszuführen
  config = lib.mkIf isPathFinderSetappInstalled {

    # Der Einstellungsblock für die Path Finder Setapp-Version
    system.defaults = {
      "com.cocoatech.PathFinder-setapp" = {

        # Toolbar Konfiguration
        "NSToolbar Configuration PF6_browserToolbarController" = {
          "TB Display Mode" = 2;
          "TB Icon Size Mode" = 1;
          "TB Is Shown" = 1;
          "TB Size Mode" = 1;
        };

        # Lese- und Schreib-Einstellungen
        PFLaunchAtLogin = 1; # Startet Path Finder beim Login (Boolean/Integer)
        PFLabelsDisplayMode = 1; # Etiketten-Anzeigemodus
        NTDefaultCompressionFormat = 2; # Standard-Komprimierungsformat
        NTDropboxPath = ""; # Dropbox-Pfad (leer)
        NTBrowserSearchField_Mode = 54;
        hideTabBarForSingleTab = 0;
        ignoreHTMLInTextEditor = 0;
        kCommandClickOpenBehavior = 1;
        kDefaultFormatIsRichText = 0;
        kDesktopOpenFolderBehavior = 1;
        kOpenTextEditDocumentsInTextEditor = 0;
        kRevealInPathFinderBehaviorPrefKey = 2;
        kWrapToPage = 1;
        pathNavigatorBelowBrowser = 1;

        # Pfade zu externen Tools
        kNTDiffToolPath = "/usr/bin/diff";
        kTerminalApplicationPath = "com.apple.Terminal";

        # Arrays von Integern (Kontextmenü-Elemente)
        "NTContextualMenuItemMgr-contextual" = [
          5
          4
          3
          11
          31
          6
          49
          1
          21
          23
          17
          12
          1
          37
          35
          36
          15
          10
          1
          39
          1
          9
          33
        ];
      };
    };
  };
}
