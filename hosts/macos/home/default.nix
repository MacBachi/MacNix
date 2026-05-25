# Home-Manager Einstiegspunkt: alle User-Module
{
  imports = [
    ./theme.nix
    ./environment.nix
    ./shell.nix
    ./packages.nix
    ./dotfiles.nix
    ./git.nix
    ./editors.nix
    ./terminal.nix
    ./firefox.nix
  ];

  home.stateVersion = "25.05";
}
