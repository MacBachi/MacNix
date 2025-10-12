# ./darwin/packages.nix
{ pkgs, ... }: {
  # Systemweit installierte Pakete (meist GUI-Apps)
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
    vscode
    # warp-terminal
    waveterm
  ];

  # Schriftarten
  # Die äußeren eckigen Klammern wurden hier entfernt
  fonts.packages = with pkgs.nerd-fonts; [ fira-code lilex ];
}
