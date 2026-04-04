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
    _1password-gui
    _1password-cli

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
