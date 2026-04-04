# Nix-Einstellungen, GC, Store-Optimierung, Firewall, sudo
{
  system.primaryUser = "mb";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    warn-dirty = false;
    max-jobs = "auto"; # alle CPU-Kerne fuer Builds nutzen
  };

  # GC: Sonntag 03:15, loescht Generationen aelter als 2 Tage
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
