# ./darwin/macos.nix
{
  system.defaults = {
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
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.sound.beep.feedback" = 0;
      "com.apple.swipescrolldirection" = true;
      "com.apple.trackpad.enableSecondaryClick" = true;
      "com.apple.trackpad.scaling" = 1.7;
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
    CustomSystemPreferences."com.apple.Safari" = {
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
}
