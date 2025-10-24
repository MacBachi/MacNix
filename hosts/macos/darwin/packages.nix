# ./darwin/packages.nix
{ pkgs, ... }: {
  # Systemweit installierte Pakete (meist GUI-Apps)
  environment.systemPackages = with pkgs; [
    # System & WM
    yubikey-manager

    # Apps
    _1password-gui
    _1password-cli
    drawio
    iterm2
    obsidian
    waveterm
    # qflipper  #broken atm (2025-10-20)
  ];

  # Schriftarten
  # Die äußeren eckigen Klammern wurden hier entfernt
  fonts.packages = with pkgs.nerd-fonts; [ fira-code lilex ];
}
