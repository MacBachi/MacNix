# ./darwin/system.nix
{
  # Definiere den Systembenutzer
  users.users.mb = {
    name = "mb";
    home = "/Users/mb";
  };

  # Setze den Hauptbenutzer für benutzerspezifische Einstellungen (Homebrew, Dock etc.)
  system.primaryUser = "mb";

  # Grundlegende Nix-Einstellungen
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Firewall-Einstellungen
  networking.applicationFirewall.enable = true;
  networking.applicationFirewall.allowSigned = true;

  # System-State-Version
  system.stateVersion = 6;

  # sudo mit Touch ID / Apple Watch aktivieren
  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.watchIdAuth = true;

}
