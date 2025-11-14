# ./darwin/packages.nix
{ pkgs, ... }:
{
  # Systemweit installierte Pakete (meist GUI-Apps)
  # GC ist in darwin/system.nix über nix.gc bereits automatisch konfiguriert.
  environment.systemPackages = with pkgs; [
    # System & WM
    aerospace
    sketchybar
    skhd
    pinentry_mac
    yubikey-manager

    # Apps
    _1password-gui
    _1password-cli
    drawio
    iterm2
    obsidian
    teams
    waveterm
    mas

    # nix-output-monitor: TUI zur Live-Ansicht von laufenden Nix-Builds (Fortschritt, Phasen, Downloads, Fehler)
    nix-output-monitor
  ];

  # Schriftarten
  # Die äußeren eckigen Klammern wurden hier entfernt
  fonts.packages = with pkgs.nerd-fonts; [
    fira-code
    lilex
  ];
}
