# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal nix-darwin + Home Manager configuration for macOS, structured as a Nix Flake. There is no application source code here — everything is declarative system/user configuration.

## Key commands

The flake entry point is `hosts/macos/`, **not** the repo root. All flake-aware commands must reference that directory.

```bash
# Rebuild everything (defined in home/shell.nix as a zsh function — only available inside this user's shell)
# Interactive: prompts for mode (switch / build / dry-run); RENIX_MODE=s|b|d to skip prompt
renix              # mas upgrade → backup lock → flake update → darwin-rebuild → nix GC → brew cleanup
renix --no-update  # skip nix flake update (use current lock as-is)
renix --no-gc      # skip GC
renix --no-mas     # skip Mac App Store
renix --no-rebuild # only run GC/cleanup
renix --rollback   # fzf-pick a previous flake.lock backup and rebuild (implies --no-update)
renix --list-locks # show available flake.lock backups
renix --logs       # show recent run logs

# Non-interactive shortcuts (CI / scripting):
RENIX_MODE=s renix                          # force switch, skip prompt
RENIX_MODE=b renix                          # build only, show closure diff
RENIX_MODE=d renix                          # dry-run (eval only)
RENIX_AUTOROLLBACK=1 renix                  # on failure after update, lock auto-restored

# Manual rebuild (when renix isn't available, e.g. fresh checkout)
# Note: must quote the flake URL — zsh with EXTENDED_GLOB treats '#' as a glob qualifier
sudo darwin-rebuild switch --flake "$HOME/mynix/hosts/macos#$(scutil --get LocalHostName)"

# Fresh-machine bootstrap: before the first darwin-rebuild, move conflicting
# system files aside or activation fails:
#   sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
#   sudo mv /etc/zshrc  /etc/zshrc.before-nix-darwin

# Debugging a Home Manager module in isolation (without darwin-rebuild)
nix build $HOME/mynix/hosts/macos#homeManagerConfigurations.<host>.activationPackage
```

**Lock backups** live in `$XDG_STATE_HOME/mynix/flake-locks/` (= `~/.local/state/mynix/flake-locks/`), one timestamped file per `renix` run, last 20 retained.

**Run logs** live in `$XDG_STATE_HOME/mynix/logs/` (= `~/.local/state/mynix/logs/`), one file per `renix` run (header with host/args/mode/tool versions/nixpkgs rev, full stdout+stderr, footer with duration+exit code), last 20 retained. When a build fails, the path is printed as `[renix] log: <path>` and the **failed derivations' build logs are auto-extracted and appended** (via `nix log`) — pasting just that one file is enough to diagnose, no need to dig through `/nix/var/log/nix/drvs/`.

Both directories are host-local and not tracked in git — each machine has its own history.

The hostname (from `scutil --get LocalHostName`) **must** match an entry in `flake.nix` (currently: `rizzo2025`, `beaker2025`, `scooter2016`). Adding a new machine = adding its hostname to `aarch64_hosts` or `x86_64_hosts` in [hosts/macos/flake.nix](hosts/macos/flake.nix).

## Architecture

Three-layer composition, wired together in [hosts/macos/flake.nix](hosts/macos/flake.nix):

1. **`darwin/`** — system-level (nix-darwin). Imported by `darwin/default.nix`, which also wires Home Manager via `home-manager.users.mb = { imports = [ ../home ]; }`.
2. **`home/`** — user-level (Home Manager). All modules listed in `home/default.nix`.
3. **`develop/flake.nix`** — standalone Python dev shell (Poetry + ruff + mypy). Independent of the system flake; entered with `nix develop` from inside a project that copies it.

`mkHostConfigs` in `flake.nix` generates one `darwinConfiguration` per hostname. `mac-app-util` is only injected for `aarch64-darwin` (Apple Silicon) — when adding x86 logic, be aware the modules list diverges by arch.

### Cross-module conventions

- **Theme palette** lives in [home/theme.nix](hosts/macos/home/theme.nix) as a Nix option (`config.theme.catppuccin-mocha`). Consumers (`shell.nix` Starship, `terminal.nix` Tmux, `firefox.nix` userChrome.css) read it via `config.theme.catppuccin-mocha` — do **not** hardcode hex colors elsewhere.
- **Homebrew uses `cleanup = "zap"`** ([darwin/homebrew.nix](hosts/macos/darwin/homebrew.nix)): any cask/brew not declared here is **removed on every rebuild**. Don't `brew install` manually — add it to the file.
- **`flake.lock` is gitignored** (see `.gitignore` — "bewusst ungetrackt"). `renix` runs `nix flake update` by default and backs up the previous lock to `$XDG_STATE_HOME/mynix/flake-locks/` for rollback. Don't commit it — hosts would diverge.
- **`.claude/` is gitignored** — local Claude Code settings are not shared.
- **Existing code comments are in German.** Match that style when editing existing files; the convention is short, lowercase, intent-focused (e.g. `# Nix-Einstellungen, GC, Store-Optimierung`).

### Where things live

- New CLI tool from nixpkgs → `home/packages.nix`
- New GUI app or CLI only on Homebrew → `darwin/homebrew.nix` (cask or brew)
- New Mac App Store app → `homebrew.masApps` (needs app ID, find via `mas search`)
- New shell alias → `home/dotfiles.nix` (`home.shellAliases`) — this file also holds **per-user macOS defaults** (`targets.darwin.defaults`, distinct from system-wide defaults in `darwin/macos.nix`) and the **fabric-ai config** stub
- New session variable → `home/environment.nix`
- New system-wide macOS default (Finder, Dock, etc.) → `darwin/macos.nix`
- Editor config → `home/editors.nix` (and `home/neovim/init.lua` for Neovim Lua)
- Firefox `user.js` prefs or `userChrome.css` → `home/firefox.nix` (generated files are symlinked into the default profile via `home.activation`)

## Things that will trip you up

- The `renix` function shells out via `eval`; if you change its argument parsing in `home/shell.nix`, test with `renix --help` after rebuild.
- `renix --rollback` needs `fzf` and at least one prior `renix` run (which is what creates the first backup). On a fresh checkout there will be no backups to roll back to.
- `home.sessionPath` includes `/opt/homebrew/bin` — brews installed via Nix's Homebrew module are on PATH automatically, no manual prepending needed.
- `system.primaryUser = "mb"` and `users.users.mb.uid = 501` are hardcoded — this is a single-user config, not multi-user generic.
- Firewall is set to `allowSigned = false` (signed-app block, "congress mode"). This is intentional; don't relax it without asking.
- **Automatic maintenance is already scheduled** in `darwin/system.nix`: Nix GC runs weekly (Sun 03:15, deletes generations >2 days old) and Nix store optimization runs weekly (Sun 04:00). Don't add a second GC schedule.
- **Firefox activation is conditional on a prior launch**: `home/firefox.nix` discovers the default profile via `~/Library/Application Support/Firefox/profiles.ini` and gracefully no-ops if it's missing. On a fresh machine, launch Firefox once, then re-run `renix` so `user.js` + `userChrome.css` actually get linked.
