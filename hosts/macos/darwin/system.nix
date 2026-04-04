# ./darwin/system.nix
{
  # Hauptbenutzer für benutzerspezifische Einstellungen (Homebrew, Dock etc.)
  system.primaryUser = "mb";

  # Grundlegende Nix-Einstellungen
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    warn-dirty = false;
    max-jobs = "auto";
  };

  # Garbage Collection
  nix.gc = {
    automatic = true;
    interval = [
      {
        Hour = 3;
        Minute = 15;
        Weekday = 7;
      }
    ];
    options = "--delete-older-than 2d";
  };

  # Nix Store Optimierung (Hardlinks fuer identische Dateien)
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

  # Unfreie Pakete erlauben (z.B. Chrome, VSCode)
  nixpkgs.config.allowUnfree = true;

  # Firewall-Einstellungen
  networking.applicationFirewall = {
    enable = true;
    allowSigned = false; ## false = congress mode, true=normal mode
    enableStealthMode = true;
  };

  # System-State-Version
  system.stateVersion = 6;

  # sudo mit Touch ID / Apple Watch aktivieren
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    watchIdAuth = true;
  };

}
