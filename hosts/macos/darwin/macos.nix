# macOS Defaults: Keyboard, Trackpad, Safari, Finder, Dock, etc.
# Aenderungen werden nach Rebuild ohne Logout aktiviert (postActivation)
{
  system.defaults = {

    # Deaktivierte Hotkeys (Konflikte mit Aerospace/skhd vermeiden)
    CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          "28"  = { enabled = false; }; # Screenshot: Fullscreen to file
          "29"  = { enabled = false; }; # Screenshot: Fullscreen to clipboard
          "30"  = { enabled = false; }; # Screenshot: Selection to file
          "31"  = { enabled = false; }; # Screenshot: Selection to clipboard
          "185" = { enabled = false; }; # Screenshot: Options
          "122" = { enabled = false; }; # Focus: Menu bar
          "123" = { enabled = false; }; # Focus: Dock
          "125" = { enabled = false; }; # Focus: Toolbar
          "126" = { enabled = false; }; # Focus: Floating windows
          "60"  = { enabled = false; }; # Input source: Previous
          "61"  = { enabled = false; }; # Input source: Next
        };
      };
      "com.apple.AppleMultitouchTrackpad" = {
        Clicking = 1;
        Dragging = 1;
        TrackpadThreeFingerDrag = 1;
      };
    };

    CustomSystemPreferences = {
      # Safari: DuckDuckGo, kein Autofill, Privacy-fokussiert
      "com.apple.Safari" = {
        AlwaysRestoreSessionAtLaunch = false;
        AutoFillCreditCardData = false;
        AutoFillFromAddressBook = true;
        AutoFillMiscellaneousForms = false;
        AutoFillPasswords = false;
        AutoOpenSafeDownloads = false;
        EnableEnhancedPrivacyInRegularBrowsing = true;
        HistoryAgeInDaysLimit = 1;
        HomePage = "https://homepage.secure.guggug.at/";
        IncludeDevelopMenu = true;
        NewTabBehavior = 4;
        SearchProviderShortName = "DuckDuckGo";
        ShowFullURLInSmartSearchField = true;
        ShowOverlayStatusBar = true;
        WarnAboutFraudulentWebsites = true;
        ExtensionsEnabled = 1;
        GrammarCheckingEnabled = 0;
        ShowSidebarInNewWindows = 1;
        ShowSidebarInTopSites = 1;
        SpellCheckingEnabled = 0;
        WebContinuousSpellCheckingEnabled = 0;
        "WebKitPreferences.applePayEnabled" = 1;
      };
      "com.apple.TimeMachine" = {
        EncryptBackups = true;
      };
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;
        CriticalUpdateInstall = 1;
      };
    };

    WindowManager = {
      EnableStandardClickToShowDesktop = false;
    };

    loginwindow = {
      GuestEnabled = false;
      LoginwindowText = "🤙 markus@bachlechner.org, ☎️ +4368110274079, 🌍 Austria ";
      PowerOffDisabledWhileLoggedIn = false;
      RestartDisabled = false;
      RestartDisabledWhileLoggedIn = false;
      SHOWFULLNAME = false;
      ShutDownDisabled = false;
      ShutDownDisabledWhileLoggedIn = false;
      SleepDisabled = false;
      autoLoginUser = "Off";
    };

    menuExtraClock = {
      FlashDateSeparators = false;
      IsAnalog = false;
      Show24Hour = true;
      ShowDate = 2;
      ShowSeconds = false;
    };

    # Dock: rechts, keine Recents, Hot Corners aktiv
    # Hot Corners: bl=Mission Control, tr=Screen Saver, br=Notification Center
    dock = {
      autohide = false;
      show-recents = false;
      wvous-bl-corner = 2;
      wvous-tr-corner = 5;
      wvous-br-corner = 12;
      tilesize = 32;
      magnification = false;
      mineffect = "scale";
      minimize-to-application = true;
      mru-spaces = false;
      orientation = "right";
      persistent-apps = [
        "/Applications/Setapp/Path Finder.app"
        "/Applications/Safari.app"
        "/Applications/Orion.app"
        "/System/Applications/Messages.app"
        "/Applications/Nix Apps/Wave.app"
        "/Applications/Nix Apps/1Password.app"
        "/System/Applications/Mail.app"
        "/Applications/Nix Apps/Obsidian.app"
        "/Applications/Setapp/Numi.app"
        "/Applications/Signal.app"
      ];
    };

    # Finder: Listenansicht, POSIX-Pfad in Titelleiste
    finder = {
      FXPreferredViewStyle = "Nlsv";
      AppleShowAllExtensions = true;
      AppleShowAllFiles = false;
      CreateDesktop = true;
      FXDefaultSearchScope = "SCcf";
      ShowPathbar = true;
      ShowRemovableMediaOnDesktop = false;
      ShowExternalHardDrivesOnDesktop = false;
      ShowHardDrivesOnDesktop = false;
      ShowMountedServersOnDesktop = false;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
      FXEnableExtensionChangeWarning = false;
      FXRemoveOldTrashItems = true;
      NewWindowTarget = "Documents";
    };

    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 3;
    };
    spaces = {
      spans-displays = false;
    };
    LaunchServices = {
      LSQuarantine = true;
    };

    # Globale Einstellungen: 24h, Celsius, metrisch, keine Autokorrektur
    NSGlobalDomain = {
      AppleEnableSwipeNavigateWithScrolls = true;
      AppleEnableMouseSwipeNavigateWithScrolls = true;
      AppleICUForce24HourTime = true;
      AppleInterfaceStyleSwitchesAutomatically = true;
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      ApplePressAndHoldEnabled = true;
      AppleSpacesSwitchOnActivate = true;
      AppleTemperatureUnit = "Celsius";
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticInlinePredictionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSTextShowsControlCharacters = false;
      NSUseAnimatedFocusRing = true;
      NSWindowShouldDragOnGesture = true;
      PMPrintingExpandedStateForPrint = true;
    };

    SoftwareUpdate = {
      AutomaticallyInstallMacOSUpdates = true;
    };
    hitoolbox = {
      AppleFnUsageType = "Show Emoji & Symbols";
    };
    iCal = {
      CalendarSidebarShown = true;
    };

    controlcenter = {
      AirDrop = true;
      BatteryShowPercentage = true;
      Bluetooth = true;
      Display = false;
      FocusModes = true;
      NowPlaying = true;
      Sound = false;
    };
  };

  # Caps Lock -> Control, Tilde-Remap fuer non-US Keyboards
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
    nonUS.remapTilde = true;
  };

  # Settings sofort aktivieren ohne Logout
  system.activationScripts.postActivation.text = ''
      sudo -u mb /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';
}
