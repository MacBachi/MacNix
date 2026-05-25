# MacNix

Personal [Nix](https://nixos.org/) configuration for macOS, managed with [nix-darwin](https://github.com/LnL7/nix-darwin) and [Home Manager](https://github.com/nix-community/home-manager). Structured as a [Nix Flake](https://nixos.wiki/wiki/Flakes) for reproducible, declarative system management.

## Features

- **Declarative system & user config** via nix-darwin + Home Manager
- **Homebrew integration** for casks, brews, and Mac App Store apps
- **Shell**: Zsh with Oh-my-zsh, Starship prompt (Catppuccin Mocha theme)
- **Editors**: Neovim (LSP, Treesitter, Telescope) and VSCode
- **Terminal**: Tmux (Catppuccin), Waveterm, Bat, Eza, Fzf
- **Git**: SSH signing via 1Password, diff-so-fancy
- **Security**: Firewall with stealth mode, Touch ID / Apple Watch sudo
- **Maintenance**: Automatic GC, store optimization, brew cleanup via `renix`

Some apps are managed via Setapp and not yet integrated into Nix.

## Structure

```
hosts/macos/
├── flake.nix                 # Main flake (3 hosts: rizzo2025, beaker2025, scooter2016)
├── darwin/                   # System-level (nix-darwin)
│   ├── default.nix           # Imports + Home Manager wiring
│   ├── system.nix            # Nix settings, GC, store optimization, firewall, sudo
│   ├── packages.nix          # System packages (GUI apps, fonts)
│   ├── homebrew.nix          # Brews, casks, Mac App Store apps
│   ├── macos.nix             # macOS defaults (Finder, Dock, Safari, keyboard)
│   └── users.nix             # User definitions
├── home/                     # User-level (Home Manager)
│   ├── default.nix           # Imports all home modules
│   ├── theme.nix             # Catppuccin Mocha palette (shared across modules)
│   ├── environment.nix       # Session variables, locale, XDG dirs
│   ├── shell.nix             # Zsh, Oh-my-zsh, Starship, renix function
│   ├── packages.nix          # CLI user packages
│   ├── editors.nix           # Neovim + VSCode config
│   ├── terminal.nix          # Tmux, Waveterm, Bat, Eza, Fzf, htop, lf
│   ├── git.nix               # Git, SSH, GPG, diff-so-fancy
│   ├── dotfiles.nix          # Shell aliases, macOS user-defaults, fabric config
│   └── neovim/init.lua       # Neovim Lua config
└── develop/
    └── flake.nix             # Standalone Python dev environment
```

## Installation

Prerequisites: macOS, [Nix](https://nixos.org/download.html) with Flakes enabled, [Homebrew](https://brew.sh).

```bash
# 1. Install Nix
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)

# 2. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Clone
git clone https://github.com/MacBachi/MacNix.git ~/mynix
cd ~/mynix

# 4. Add your hostname to flake.nix (aarch64_hosts or x86_64_hosts)

# 5. First build (move conflicting system files first)
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
sudo nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake $HOME/mynix/hosts/macos
```

## Daily Usage

### renix — the main rebuild command

After any config change, run `renix` in your shell. It handles everything:

```
renix [options]
  --no-update    Skip nix flake update
  --no-gc        Skip garbage collection
  --no-mas       Skip Mac App Store upgrade
  --no-rebuild   Skip darwin-rebuild
  --rollback     Pick previous flake.lock via fzf and rebuild
  --list-locks   List available flake.lock backups
  --logs         List recent renix run logs
  --help         Show help

ENV overrides:
  RENIX_MODE=s|b|d        Skip mode prompt: switch / build / dry-run
  RENIX_AUTOROLLBACK=1    On rebuild failure after update, auto-restore previous lock
```

At the start of each interactive run, `renix` asks for the **rebuild mode**:

- **switch** (default, just press Enter): build + activate (the normal rebuild)
- **build**: build without activating, then show `nix store diff-closures` against the live system — see exactly which packages would change, without committing
- **dry-run**: only evaluate the flake and report what would be built (no actual build)

What `renix` does (switch mode):
1. Upgrades Mac App Store apps (`mas upgrade`)
2. Backs up current `flake.lock` to `$XDG_STATE_HOME/mynix/flake-locks/flake.lock.<timestamp>` (last 20 retained)
3. Runs `nix flake update` (pulls latest inputs)
4. Runs `darwin-rebuild switch` (applies nix + homebrew changes)
5. Runs `nix-collect-garbage -d`
6. Runs `brew cleanup --prune=7`
7. Shows Nix store size

(build / dry-run skip steps 4–7.)

Every run is logged to `$XDG_STATE_HOME/mynix/logs/renix.<timestamp>.log` — header with host, args, mode, tool versions, nixpkgs revision; full stdout/stderr; footer with duration + exit code. Last 20 logs retained.

**On build failure**, renix automatically extracts the failed derivations' build logs (via `nix log`) and appends them to the run log — no more hunting through `/nix/var/log/nix/drvs/`.

### Rollback

If a rebuild breaks after an update, pick a previous `flake.lock`:

```bash
renix --rollback          # fzf-Picker, restore lock, rebuild without update
renix --list-locks        # list available backups
renix --logs              # list recent run logs (paste path to your AI assistant for debugging)
```

Backups and logs are host-local (not in git), so each machine has its own history.

## Automatic Maintenance

Configured in `darwin/system.nix`:
- **Nix GC**: Weekly (Sunday 03:15), deletes generations older than 2 days
- **Nix Store optimization**: Weekly (Sunday 04:00), hardlinks identical files
- **Homebrew**: `onActivation.cleanup = "zap"` removes unused packages on every rebuild
