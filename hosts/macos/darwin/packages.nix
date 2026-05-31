# Systemweite Nix-Pakete (GUI-Apps, WM, Fonts)
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Window-Management
    aerospace
    sketchybar
    skhd

    # Security
    pinentry_mac
    yubikey-manager
    # 1password GUI + CLI via Homebrew (siehe homebrew-shared.nix) -
    # nixpkgs-Hash drift hat Builds auf Hosts mit Inspection-Proxy gebrochen.

    # Apps
    drawio
    iterm2
    obsidian
    waveterm

    # Build-Monitoring
    nix-output-monitor
  ];

  fonts.packages = with pkgs.nerd-fonts; [
    fira-code
    lilex
  ];
}
