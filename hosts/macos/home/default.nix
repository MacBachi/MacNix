# ./home/home.nix
{
  imports = [
    ./packages.nix
    ./shell.nix
    ./environment.nix
    ./macbachi.nix
  ];

  # Home Manager Basiskonfiguration #
  home = {
    username = "mb";
    homeDirectory = "/Users/mb";
    stateVersion = "25.05"; # Setze auf die aktuelle Version
  };

  # Home Manager Programme aktivieren #
  programs.home-manager.enable = true;
}
