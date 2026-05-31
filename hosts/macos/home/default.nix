# Home-Manager Einstiegspunkt: Module die auf JEDEM Host gelten.
# packages-{shared,private,work}.nix wandern via per-host/HOSTNAME.nix rein.
{
  imports = [
    ./theme.nix
    ./environment.nix
    ./shell.nix
    ./dotfiles.nix
    ./git.nix
    ./editors.nix
    ./terminal.nix
    ./firefox.nix
  ];

  home.stateVersion = "25.05";
}
