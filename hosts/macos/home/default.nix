# ./home/home.nix
{
  imports = [
    ./packages.nix
    ./shell.nix
    ./environment.nix
  ];

  # Home Manager Basiskonfiguration
  home = {
    username = "mb";
    homeDirectory = "/Users/mb";
    stateVersion = "23.11"; # Setze auf die aktuelle Version
  };

  # Home Manager Programme aktivieren
  programs.home-manager.enable = true;
}
