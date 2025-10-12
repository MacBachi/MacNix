## Install NIX

```
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```

```
nix-shell -p git --run 'git clone https://github.com/MacBachi/MacNix.git $HOME/mynix'
```

```
sudo nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake $HOME/mynix/hosts/macos
```

