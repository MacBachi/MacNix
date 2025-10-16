## Install NIX

```
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

```

```
nix-shell -p git --run 'git clone https://github.com/MacBachi/MacNix.git $HOME/mynix'
```

```
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zhsrc.before-nix-darwin
```

```
sudo nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake $HOME/mynix/hosts/macos
```

## Rebuild NIX
```
sudo darwin-rebuild switch --flake $HOME/mynix/hosts/macos#$(scutil --get LocalHostName)
```

## Maintain NIX

Garbage Collection
```
nix-collect-garbage -d
```

Diskspace NIX is using
```
du -sh /nix/store
```


```
nix flake update --flake $HOME/mynix/hosts/macos
sudo darwin-rebuild switch --flake $HOME/mynix/hosts/macos#$(scutil --get LocalHostName)
```
