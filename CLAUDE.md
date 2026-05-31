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

The hostname (from `scutil --get LocalHostName`) **must** match a key in the `hosts` attrset in [hosts/macos/flake.nix](hosts/macos/flake.nix) (currently: `rizzo2025`, `beaker2025`, `scooter2016`, `PN1030UZ2568748`). Adding a new machine = adding an entry with `{ system, user, uid, extras }` plus a per-host overlay file at `hosts/macos/per-host/<hostname>.nix`.

## Architecture

Four-layer composition, wired together in [hosts/macos/flake.nix](hosts/macos/flake.nix):

1. **`darwin/`** — system-level (nix-darwin). `darwin/default.nix` imports the always-on modules (`system`, `packages`, `macos`, `users`) and wires Home Manager via `home-manager.users.${user} = { imports = [ ../home ]; }`. `user` and `uid` are passed via `specialArgs` per host.
2. **`home/`** — user-level (Home Manager). `home/default.nix` imports the always-on modules. Per-host content (packages, brews, casks, masApps) comes from the split files below.
3. **`per-host/<hostname>.nix`** — per-host overlay. Picks which `*-shared` / `*-private` / `*-work` fragments to import. This is where host divergence is declared. Wired in via the host's `extras` list in `flake.nix`.
4. **`develop/flake.nix`** — standalone Python dev shell (Poetry + ruff + mypy). Independent of the system flake; entered with `nix develop` from inside a project that copies it.

`mkDarwinConfig` and `mkHomeConfig` in `flake.nix` iterate the `hosts` attrset via `builtins.mapAttrs`, producing one `darwinConfiguration` (and matching standalone home-manager config) per host. `mac-app-util` is only injected for `aarch64-darwin` (Apple Silicon) — when adding x86 logic, be aware the modules list diverges by arch.

### Shared / private / work split

Two host flavors exist: private machines (3x: `rizzo2025`, `beaker2025`, `scooter2016`) and the corporate machine `PN1030UZ2568748`. To avoid host-specific tools leaking onto the wrong machine, `home/packages.nix` and `darwin/homebrew.nix` are each split into three files:

- **`*-shared.nix`** — gilt überall (every host imports it via its per-host file).
- **`*-private.nix`** — only on private machines. Hold tools that EDR/corporate-policy would flag (offensive security, container CLI, personal apps).
- **`*-work.nix`** — only on the work machine. Holds work-only additions (extra MS-Suite apps that aren't in shared).

The base homebrew settings (`enable`, `user`, `onActivation`) live **only** in `homebrew-shared.nix`. Private/work files contribute *additions* (`homebrew.casks`, `homebrew.brews`, `homebrew.masApps`) which the module system merges. **Do not** declare `homebrew.enable` in the non-shared files — it conflicts.

### Cross-module conventions

- **Theme palette** lives in [home/theme.nix](hosts/macos/home/theme.nix) as a Nix option (`config.theme.catppuccin-mocha`). Consumers (`shell.nix` Starship, `terminal.nix` Tmux, `firefox.nix` userChrome.css) read it via `config.theme.catppuccin-mocha` — do **not** hardcode hex colors elsewhere.
- **Homebrew uses `cleanup = "zap"`** ([darwin/homebrew-shared.nix](hosts/macos/darwin/homebrew-shared.nix)): any cask/brew not declared in shared/private/work (whichever applies for the active host) is **removed on every rebuild**. Don't `brew install` manually — add it to the appropriate split file.
- **`flake.lock` is gitignored** (see `.gitignore` — "bewusst ungetrackt"). `renix` runs `nix flake update` by default and backs up the previous lock to `$XDG_STATE_HOME/mynix/flake-locks/` for rollback. Don't commit it — hosts would diverge.
- **`.claude/` is gitignored** — local Claude Code settings are not shared.
- **Existing code comments are in German.** Match that style when editing existing files; the convention is short, lowercase, intent-focused (e.g. `# Nix-Einstellungen, GC, Store-Optimierung`).

### Where things live

- New CLI tool from nixpkgs → `home/packages-shared.nix` (or `-private.nix` / `-work.nix` if host-specific)
- New GUI app or CLI only on Homebrew → `darwin/homebrew-shared.nix` (or `-private.nix` / `-work.nix`). Decide by: is this tool offensive/personal (→ private), work-only (→ work), or universal (→ shared)?
- New Mac App Store app → same split files, under the `homebrew.masApps` attrset (needs app ID, find via `mas search`)
- New machine → add entry to `hosts` attrset in `flake.nix` and create `hosts/macos/per-host/<hostname>.nix` that imports the right shared/private/work fragments
- New shell alias → `home/dotfiles.nix` (`home.shellAliases`) — this file also holds **per-user macOS defaults** (`targets.darwin.defaults`, distinct from system-wide defaults in `darwin/macos.nix`) and the **fabric-ai config** stub
- New session variable → `home/environment.nix`
- New system-wide macOS default (Finder, Dock, etc.) → `darwin/macos.nix`
- Editor config → `home/editors.nix` (and `home/neovim/init.lua` for Neovim Lua)
- Firefox `user.js` prefs or `userChrome.css` → `home/firefox.nix` (generated files are symlinked into the default profile via `home.activation`)

## Things that will trip you up

- The `renix` function shells out via `eval`; if you change its argument parsing in `home/shell.nix`, test with `renix --help` after rebuild.
- `renix --rollback` needs `fzf` and at least one prior `renix` run (which is what creates the first backup). On a fresh checkout there will be no backups to roll back to.
- `home.sessionPath` includes `/opt/homebrew/bin` — brews installed via Nix's Homebrew module are on PATH automatically, no manual prepending needed.
- **`user` and `uid` come from `specialArgs`** (set per host in `flake.nix:hosts`). Never hardcode `"mb"` or `501` in modules — read from the function arguments. `darwin/users.nix` uses `users.users.${user}` (dynamic attr name).
- Firewall is set to `allowSigned = false` (signed-app block, "congress mode"). This is intentional; don't relax it without asking.
- **GC is a custom launchd daemon** in `darwin/system.nix` (`nix-smart-gc`, Sun 03:15): keeps at least the latest 2 system generations AND anything younger than 7 days; deletes the rest. Log at `/var/log/nix-smart-gc.log`. `nix.gc.automatic = false` is intentional — built-in `--delete-older-than` has no "keep min N" floor, which previously left the system with zero rollback targets after long idle periods. Nix store optimization is still on the built-in schedule (Sun 04:00).
- **`renix` no longer runs `nix-collect-garbage -d`** (only `nix-collect-garbage` without `-d`). Generation pruning is the smart-gc daemon's job alone; renix only cleans dereferenced store paths.
- **Corporate Mac bootstrap** (`PN1030UZ2568748`): the user (`U1131JN`, uid 502) is pre-created by Intune onboarding before Nix ever runs. nix-darwin adopts the existing user; the `uid` in `flake.nix:hosts` **must** match the actual uid the system assigned (verify via `id -u` before first build) or activation will fail.
- **Firefox activation is conditional on a prior launch**: `home/firefox.nix` discovers the default profile via `~/Library/Application Support/Firefox/profiles.ini` and gracefully no-ops if it's missing. On a fresh machine, launch Firefox once, then re-run `renix` so `user.js` + `userChrome.css` actually get linked.
