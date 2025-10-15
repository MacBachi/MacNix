# ./home/default.nix
{
  imports = [
    ./environment.nix
    ./macbachi.nix
    ./packages.nix
    ./shell.nix
  ];

  home = {
    stateVersion = "25.05";
  };
}
