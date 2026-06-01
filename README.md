# MacNix

Personal [Nix](https://nixos.org/) configuration for macOS, managed with [nix-darwin](https://github.com/nix-darwin/nix-darwin) and [Home Manager](https://github.com/nix-community/home-manager). Structured as a [Nix Flake](https://nixos.wiki/wiki/Flakes) for reproducible, declarative system management across multiple machines (private + corporate).

## Features

- **Declarative system & user config** via nix-darwin + Home Manager
- **Multi-host** — 3 private Macs (2x aarch64, 1x x86) and 1 corporate aarch64 Mac, with per-host overlays via a shared/private/work module split
- **Homebrew integration** for casks, brews, and Mac App Store apps (with corporate-proxy-friendly download tweaks)
- **Shell**: Zsh with Oh-my-zsh, Starship prompt (Catppuccin Mocha theme)
- **Editors**: Neovim (LSP, Treesitter, Telescope) and VSCode
- **Terminal**: Tmux (Catppuccin), Waveterm, Bat, Eza, Fzf
- **Git**: SSH signing via 1Password, diff-so-fancy
- **Security**: Firewall with stealth mode, Touch ID / Apple Watch sudo
- **Maintenance**: Smart GC daemon (min-2 generations + min-7-days floor), store optimization, brew cleanup via `renix`

Some apps are managed via Setapp and not yet integrated into Nix. **1Password is installed manually** (auto-updates itself thereafter — see Manual installs below).

## Structure

```
hosts/macos/
├── flake.nix                       # 4 hosts: rizzo2025, beaker2025, scooter2016, PN1030UZ2568748
├── darwin/                         # System-level (nix-darwin)
│   ├── default.nix                 # Imports + Home Manager wiring (user from specialArgs)
│   ├── system.nix                  # Nix settings, smart-gc daemon, firewall, sudo
│   ├── packages.nix                # System packages (GUI apps, fonts)
│   ├── homebrew-shared.nix         # Brews/Casks/MAS on every host + brew env tweaks
│   ├── homebrew-private.nix        # Private-only (offensive tools, container CLI, etc.)
│   ├── homebrew-work.nix           # Work-only (Outlook/OneNote/Teams, Edge)
│   ├── macos.nix                   # macOS defaults (Finder, Dock, Safari, keyboard)
│   ├── users.nix                   # User definition (parametrized via specialArgs)
│   └── preflight.nix               # "Missing manual install" warning (1Password)
├── home/                           # User-level (Home Manager)
│   ├── default.nix                 # Always-on modules
│   ├── theme.nix                   # Catppuccin Mocha palette
│   ├── environment.nix             # Session variables, locale, XDG dirs
│   ├── shell.nix                   # Zsh, Oh-my-zsh, Starship, renix function
│   ├── packages-shared.nix         # CLI packages on every host
│   ├── packages-private.nix        # Private-only packages
│   ├── packages-work.nix           # Work-only packages
│   ├── editors.nix                 # Neovim + VSCode config
│   ├── terminal.nix                # Tmux, Waveterm, Bat, Eza, Fzf, htop, lf
│   ├── git.nix                     # Git, SSH, GPG, diff-so-fancy
│   ├── dotfiles.nix                # Shell aliases, per-user macOS defaults, fabric config
│   ├── firefox.nix                 # user.js + userChrome.css via home.activation
│   └── neovim/init.lua             # Neovim Lua config
├── per-host/                       # One file per host — declares which fragments it imports
│   ├── rizzo2025.nix               # shared + private
│   ├── beaker2025.nix              # shared + private
│   ├── scooter2016.nix             # shared + private
│   └── PN1030UZ2568748.nix         # shared + work + Dock override (Edge after Firefox)
└── develop/
    └── flake.nix                   # Standalone Python dev environment
```

The `hosts` attrset in `flake.nix` maps each hostname to `{ system, user, uid, extras }`. Adding a host = adding an entry plus a `per-host/<hostname>.nix` file.

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

# 4. Add your hostname to the hosts attrset in hosts/macos/flake.nix
#    plus a per-host/<hostname>.nix file (copy one of the existing ones)

# 5. First build (move conflicting system files first)
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
sudo nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake $HOME/mynix/hosts/macos

# 6. Install 1Password manually from https://1password.com/downloads/mac
#    (intentionally outside nix — preflight will warn if missing)
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

- **switch** (default): build + activate
- **build**: build without activating, then show `nix store diff-closures` against the live system — see exactly which packages would change, without committing
- **dry-run**: only evaluate the flake and report what would be built

What `renix` does (switch mode):
1. Upgrades Mac App Store apps (`mas upgrade`)
2. Backs up current `flake.lock` to `$XDG_STATE_HOME/mynix/flake-locks/flake.lock.<timestamp>` (last 20 retained)
3. Runs `nix flake update` (pulls latest inputs)
4. Runs `darwin-rebuild switch` (applies nix + homebrew changes)
5. Runs `nix-collect-garbage` (without `-d` — generation pruning is the smart-gc daemon's job)
6. Runs `brew cleanup --prune=7`
7. Shows Nix store size

(build / dry-run skip steps 4–7.)

Every run is logged to `$XDG_STATE_HOME/mynix/logs/renix.<timestamp>.log`. **On build failure**, renix automatically extracts the failed derivations' build logs and appends them to the run log — paste that one file to diagnose.

### Workmac caveat — GitHub API rate limit

The corporate NAT shares an IP with many users, hitting GitHub's unauthenticated API rate limit when nix tries to update flake inputs. Even `renix --no-update` doesn't help because `darwin-rebuild` itself tries to update flake.lock when it sees an unlocked input. Workaround: bypass `renix` and pass `--no-write-lock-file` directly:

```bash
sudo darwin-rebuild switch --flake "$HOME/mynix/hosts/macos#$(scutil --get LocalHostName)" --no-write-lock-file
```

This builds with the existing flake.lock unchanged. `renix` doesn't pass that flag through.

### Rollback

If a rebuild breaks after an update, pick a previous `flake.lock`:

```bash
renix --rollback          # fzf-Picker, restore lock, rebuild without update
renix --list-locks        # list available backups
renix --logs              # list recent run logs
```

Backups and logs are host-local (not in git), so each machine has its own history.

## Automatic Maintenance

Configured in `darwin/system.nix`:

- **Smart GC daemon (`nix-smart-gc`)**: weekly (Sunday 03:15). Keeps at least the latest 2 system generations AND anything younger than 7 days; deletes the rest. Logs to `/var/log/nix-smart-gc.log`. Replaces the built-in `nix.gc` which has no min-N floor — the previous "delete-older-than 2d" config could leave the system with zero rollback targets after idle periods.
- **Nix Store optimization**: weekly (Sunday 04:00), hardlinks identical files
- **Homebrew auto-upgrade**: daily (12:40) via `darwin/brew-auto-upgrade.nix` — runs `brew update && brew upgrade && brew cleanup --prune=7` as launchd user agent. Logs to `~/.local/state/mynix/logs/brew-upgrade.log`. Independent of `renix` (which also upgrades via `onActivation.upgrade = true`).
- **Homebrew cleanup**: `onActivation.cleanup = "zap"` removes unused packages on every rebuild

The brew activation also sets `HOMEBREW_DOWNLOAD_CONCURRENCY=1`, `HOMEBREW_FORCE_BREWED_CURL=1`, and `HOMEBREW_CURL_RETRIES=5` (in `darwin/homebrew-shared.nix`). These work around corporate inspection-proxy quirks that broke parallel cask downloads with `bad decrypt` errors. `FORCE_BREWED_CURL=1` requires `curl` itself as a brew formula (it's in the brews list).

## Manual installs

Intentionally outside nix:

- **1Password** — install from https://1password.com/downloads/mac. The auto-updater handles versions thereafter. nix-darwin attempts (via nixpkgs, brew cask, direct CDN download) all turned out unstable in the wild — version drift, hash mismatches, installer-wrapper changes inside the .zip. `darwin/preflight.nix` shows a bright red warning on every activation if the .app is missing.
- **Setapp apps** — managed by the Setapp client.
- **Apps pushed via Intune** (corporate Mac only) — security tools that IT manages separately. They live in `/Applications` outside both nix and brew tracking, so neither bothers them.
