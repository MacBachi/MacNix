# ./darwin/macos.nix
{
  system.defaults = {

    CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          "28" = {
            # Save picture of screen as a file
            enabled = false;
          };
          "29" = {
            # Copy picture of screen to the clipboard
            enabled = false;
          };
          "30" = {
            # Save picture of selected area as a file
            enabled = false;
          };
          "31" = {
            # Copy picture of selected area to the clipboard
            enabled = false;
          };
          "185" = {
            # screenshot options
            enabled = false;
          };
          "122" = {
            # Fokus auf Menüleiste
            enabled = false;
          };
          "123" = {
            # Fokus auf Dock 
            enabled = false;
          };
          "125" = {
            # Fokus auf Symbolleiste
            enabled = false;
          };
          "126" = {
            # Fokus auf Schwebende Fenster
            enabled = false;
          };
          "60" = {
            # Vorherige Eingabequelle
            enabled = false;
          };
          "61" = {
            # Nächste Eingabequelle
            enabled = false;
          };
        };
      };
      "com.apple.AppleMultitouchTrackpad" = {
        Clicking = 1;
        Dragging = 1;
        TrackpadThreeFingerDrag = 1;
      };
    };

    CustomSystemPreferences = {
      "com.apple.Safari" = {
        AlwaysRestoreSessionAtLaunch = false;
        AutoFillCreditCardData = false;
        AutoFillFromAddressBook = true;
        AutoFillMiscellaneousForms = false;
        AutoOpenSafeDownloads = false;
        EnableEnhancedPrivacyInRegularBrowsing = true;
        HistoryAgeInDaysLimit = 1;
        HomePage = "https://homepage.secure.guggug.at/";
        IncludeDevelopMenu = true;
        NewTabBehavior = 4;
        SearchProviderShortName = "DuckDuckGo";
        ShowFullURLInSmartSearchField = true;
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
        "/System/Applications/Messages.app"
        "/Applications/Nix Apps/Wave.app"
        "/Applications/Nix Apps/1Password.app"
        "/System/Applications/Mail.app"
        "/Applications/Nix Apps/Obsidian.app"
        "/Applications/Setapp/Numi.app"
        "/Applications/Signal.app"
      ];
    };
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
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
    nonUS.remapTilde = true;
  };
  system.activationScripts.postActivation.text = ''
      # Following line should allow us to avoid a logout/login cycle when changing settings
      sudo -u mb /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';
}
