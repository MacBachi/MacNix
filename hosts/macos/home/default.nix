# ./home/home.nix
{
  imports = [
    ./packages.nix
    ./shell.nix
    ./environment.nix
    ./macbachi.nix
  ];

  home = {
    username = "mb";
    homeDirectory = "/Users/mb";
    stateVersion = "25.05"; # Setze auf die aktuelle Version
  };

  programs.home-manager.enable = true;
}
