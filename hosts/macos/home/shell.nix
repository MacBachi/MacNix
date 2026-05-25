# Zsh, Oh-my-zsh, Starship Prompt, renix Rebuild-Funktion
{
  config,
  home,
  ...
}:
let
  colors = config.theme.catppuccin-mocha;
in
{
  home.sessionPath = [
    "/opt/homebrew/bin"
  ];

  programs.bash.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      path = "$HOME/.zsh_history";
      size = 20000;
      save = 20000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
    };

    initContent = ''
                  # alias-finder: automatisch passende Aliases vorschlagen
                  zstyle ':omz:plugins:alias-finder' autoload yes
                  zstyle ':omz:plugins:alias-finder' longer yes
                  zstyle ':omz:plugins:alias-finder' exact yes
                  zstyle ':omz:plugins:alias-finder' cheaper yes

                  # magic-enter: Enter ohne Befehl zeigt git status / ls
                  MAGIC_ENTER_GIT_COMMAND='git status -u .'
                  MAGIC_ENTER_OTHER_COMMAND='ls -lh .'

                  # Zusaetzliche Zsh-Optionen (History wird von programs.zsh.history gehandhabt)
                  setopt EXTENDED_GLOB AUTO_CD NO_BEEP APPEND_HISTORY \
                         HIST_REDUCE_BLANKS HIST_VERIFY INC_APPEND_HISTORY

                  setopt NO_CLOBBER  # > ueberschreibt nicht, >| erzwingen
                  setopt GLOB_DOTS   # Dotfiles in Globs einschliessen

                  : "''${RENIX_FLAKE_ROOT:=$HOME/mynix/hosts/macos}"

                  unalias renix 2>/dev/null || true

                  # rtfm: cheat.sh Lookup, Fallback auf tldr
                  rtfm() {
                    if [ -z "$1" ]; then
                      echo "Usage: rtfm <topic>"
                      return 1
                    fi
                    if curl -fsSL "https://cheat.sh/$1" >/dev/null 2>&1; then
                      curl -fsSL "https://cheat.sh/$1"
                    else
                      command -v tldr >/dev/null 2>&1 && tldr "$1" || echo "No cheat.sh or tldr available."
                    fi
                  }

                  # renix: Kompletter System-Rebuild mit Logging
                  # Flow:     1) mode-prompt 2) mas upgrade 3) lock backup+update 4) rebuild 5) GC+brew cleanup
                  # Modes:    switch (default) | build (kein activate, mit closure-diff) | dry-run (kein build)
                  #           Prompt erscheint bei interaktivem Aufruf; ueberschreibbar via RENIX_MODE=s|b|d
                  # Rollback: renix --rollback (fzf-Picker, Backups in $XDG_STATE_HOME/mynix/flake-locks)
                  # Auto-RB:  RENIX_AUTOROLLBACK=1 → bei Fehler nach Update wird Lock automatisch zurueckgesetzt
                  # Logs:     $XDG_STATE_HOME/mynix/logs/renix.<timestamp>.log (letzte 20)
                  #           Bei Build-Fehler werden fehlgeschlagene Derivation-Logs ans Run-Log angehaengt
                  renix() {
                    local host="$(scutil --get LocalHostName 2>/dev/null)"
                    local flake_root="''${RENIX_FLAKE_ROOT}"
                    local flake="''${flake_root}#''${host}"
                    local state_root="''${XDG_STATE_HOME:-$HOME/.local/state}/mynix"
                    local lock_dir="$state_root/flake-locks"
                    local log_dir="$state_root/logs"
                    local lock_retention=20
                    local log_retention=20
                    local do_gc=1
                    local do_mas=1
                    local do_rebuild=1
                    local do_update=1
                    local do_rollback=0
                    local do_list_locks=0
                    local do_list_logs=0
                    local -a passthru=()

                    for a in "$@"; do
                      case "$a" in
                        --no-gc) do_gc=0 ;;
                        --no-mas) do_mas=0 ;;
                        --no-rebuild) do_rebuild=0 ;;
                        --no-update) do_update=0 ;;
                        --rollback) do_rollback=1; do_update=0 ;;
                        --list-locks) do_list_locks=1 ;;
                        --logs) do_list_logs=1 ;;
                        -h|--help)
                          cat <<EOF
      renix [options] [custom rebuild command]
        --no-update    Skip nix flake update
        --no-gc        Skip nix-collect-garbage
        --no-mas       Skip mas upgrade
        --no-rebuild   Skip darwin-rebuild
        --rollback     Pick previous flake.lock via fzf and rebuild
        --list-locks   List available flake.lock backups
        --logs         List recent renix run logs
        --help         Show help
      Extra args (without --no-*) replace the default rebuild command.
      ENV: RENIX_FLAKE_ROOT='$RENIX_FLAKE_ROOT'
           RENIX_MODE=s|b|d   skip prompt: switch | build | dry-run
           RENIX_AUTOROLLBACK=1  auto-restore lock on rebuild failure after update
           Lock backups: $lock_dir (keeps last $lock_retention)
           Run logs:     $log_dir (keeps last $log_retention)
      EOF
                          return 0
                          ;;
                        --no-*) ;;
                        *) passthru+=("$a") ;;
                      esac
                    done

                    # --list-locks / --logs: nur listen, keine Aktion
                    if [ "$do_list_locks" -eq 1 ]; then
                      if [ ! -d "$lock_dir" ] || [ -z "$(ls -A "$lock_dir" 2>/dev/null)" ]; then
                        echo "[renix] no lock backups in $lock_dir"
                        return 0
                      fi
                      ls -1lt "$lock_dir"
                      return 0
                    fi
                    if [ "$do_list_logs" -eq 1 ]; then
                      if [ ! -d "$log_dir" ] || [ -z "$(ls -A "$log_dir" 2>/dev/null)" ]; then
                        echo "[renix] no logs in $log_dir"
                        return 0
                      fi
                      ls -1lt "$log_dir"
                      return 0
                    fi

                    # Mode-Auswahl: switch (default) | build (kein activate) | dry-run (kein build)
                    # ENV-Override hat Vorrang vor Prompt
                    local mode="switch"
                    case "''${RENIX_MODE:-}" in
                      s|switch)            mode="switch" ;;
                      b|build)             mode="build" ;;
                      d|dry-run|dryrun)    mode="dry-run" ;;
                    esac
                    # Prompt nur bei interaktivem TTY, kein --rollback, kein --no-rebuild, kein custom cmd
                    if [ -z "''${RENIX_MODE:-}" ] && [ -t 0 ] \
                         && [ "$do_rebuild" -eq 1 ] && [ "$do_rollback" -eq 0 ] \
                         && [ "''${#passthru[@]}" -eq 0 ]; then
                      echo ""
                      echo "[renix] Rebuild mode?"
                      echo "  [s] switch     - build + activate (default, normaler renix)"
                      echo "  [b] build only - build, closure-diff, kein activate"
                      echo "  [d] dry-run    - nur evaluieren, zeige was gebaut wuerde"
                      printf "[renix] choice [s/b/d] (Enter=s): "
                      local choice=""
                      read choice
                      case "$choice" in
                        b|B|build)            mode="build" ;;
                        d|D|dry-run|dryrun)   mode="dry-run" ;;
                        *)                    mode="switch" ;;
                      esac
                      echo "[renix] selected: $mode"
                    fi

                    # Log-Datei fuer diesen Run vorbereiten
                    mkdir -p "$log_dir"
                    local ts="$(date +%Y-%m-%dT%H-%M-%S)"
                    local log_file="$log_dir/renix.$ts.log"
                    local started_epoch="$(date +%s)"

                    # Kontext-Header (vor dem tee, nicht im Pipeline-Output)
                    {
                      echo "=== renix run ==="
                      echo "host:     $host"
                      echo "started:  $(date -Iseconds 2>/dev/null || date +%Y-%m-%dT%H:%M:%S%z)"
                      echo "args:     $*"
                      echo "mode:     $mode"
                      echo "autoroll: ''${RENIX_AUTOROLLBACK:-0}"
                      echo "user:     $USER"
                      echo "pwd:      $PWD"
                      echo "flake:    $flake"
                      echo "nix:      $(command -v nix >/dev/null && nix --version 2>/dev/null || echo n/a)"
                      echo "darwin:   $(command -v darwin-rebuild >/dev/null && darwin-rebuild --version 2>/dev/null || echo n/a)"
                      if [ -f "$flake_root/flake.lock" ]; then
                        local nixpkgs_rev
                        nixpkgs_rev="$(grep -A4 '"nixpkgs"' "$flake_root/flake.lock" 2>/dev/null | grep -m1 '"rev"' | sed 's/.*"rev": "\([^"]*\)".*/\1/')"
                        echo "nixpkgs:  ''${nixpkgs_rev:-unknown}"
                      fi
                      echo "================="
                    } > "$log_file"
                    echo "[renix] log: $log_file"

                    # Haupt-Pipeline: Output zu Terminal + Log via tee
                    # Subshell, damit die exit-codes nicht die aeussere Shell beeinflussen
                    {
                      # --rollback: fzf-Picker (fzf rendert UI direkt auf TTY, nicht durch tee)
                      if [ "$do_rollback" -eq 1 ]; then
                        if ! command -v fzf >/dev/null 2>&1; then
                          echo "[renix] fzf not installed."
                          exit 4
                        fi
                        if [ ! -d "$lock_dir" ] || [ -z "$(ls -A "$lock_dir" 2>/dev/null)" ]; then
                          echo "[renix] no lock backups in $lock_dir"
                          exit 4
                        fi
                        # kein 'local' — wir sind hier in einer Pipe-Subshell
                        pick="$(ls -1t "$lock_dir" | fzf --prompt='rollback lock> ' --height=40% --reverse \
                                  --preview="stat -f '%Sm  (%z bytes)' '$lock_dir/{}'")"
                        if [ -z "$pick" ]; then
                          echo "[renix] rollback cancelled."
                          exit 0
                        fi
                        cp "$lock_dir/$pick" "$flake_root/flake.lock"
                        echo "[renix] restored $pick -> flake.lock"
                      fi

                      if [ "$do_mas" -eq 1 ] && command -v mas >/dev/null 2>&1; then
                        echo "[renix] --- mas upgrade ---"
                        MAS_NO_AUTO_INDEX=1 mas upgrade || echo "[renix] (warn) mas upgrade failed."
                      elif [ "$do_mas" -eq 1 ]; then
                        echo "[renix] mas not installed (skip)."
                      fi

                      # Flake-Update mit timestamped Backup
                      if [ "$do_update" -eq 1 ]; then
                        if [ -f "$flake_root/flake.lock" ]; then
                          mkdir -p "$lock_dir"
                          cp "$flake_root/flake.lock" "$lock_dir/flake.lock.$ts"
                          echo "[renix] backed up lock -> $lock_dir/flake.lock.$ts"
                          ls -1t "$lock_dir" | tail -n +$((lock_retention + 1)) | while read -r old; do
                            rm -f "$lock_dir/$old"
                          done
                        fi
                        echo "[renix] --- nix flake update ---"
                        if ! nix flake update --flake "$flake_root"; then
                          echo "[renix] flake update failed."
                          exit 5
                        fi
                      fi

                      # Rebuild-Befehl je nach Mode (kein 'local' in Pipe-Subshell)
                      case "$mode" in
                        switch)
                          rebuild_cmd="sudo darwin-rebuild switch --flake \"''${flake}\""
                          ;;
                        build)
                          rebuild_cmd="nix build --out-link \"$state_root/last-build\" \"''${flake_root}#darwinConfigurations.''${host}.system\""
                          ;;
                        dry-run)
                          rebuild_cmd="nix build --dry-run \"''${flake_root}#darwinConfigurations.''${host}.system\""
                          ;;
                      esac
                      if [ "''${#passthru[@]}" -gt 0 ]; then
                        rebuild_cmd="''${passthru[*]}"
                      fi

                      if [ "$do_rebuild" -eq 1 ]; then
                        if [ "$mode" = "switch" ] && ! command -v darwin-rebuild >/dev/null 2>&1; then
                          echo "[renix] darwin-rebuild not found."
                          exit 2
                        fi
                        echo "[renix] --- $mode ---"
                        echo "[renix] cmd: $rebuild_cmd"
                        if ! eval "$rebuild_cmd"; then
                          echo "[renix] Rebuild ($mode) failed."
                          echo "[renix] Hint: 'renix --rollback' to pick a previous lock and retry."
                          echo "[renix] Hint: failed derivation logs will be appended below in $log_file"
                          exit 3
                        fi
                        # Build-Mode: zeige closure-diff gegen aktuelles System
                        if [ "$mode" = "build" ] && [ -e "$state_root/last-build" ]; then
                          echo ""
                          echo "[renix] --- closure diff vs /run/current-system ---"
                          nix store diff-closures /run/current-system "$state_root/last-build" 2>&1 || true
                        fi
                      else
                        echo "[renix] Skipping rebuild (--no-rebuild)."
                      fi

                      # GC nur nach erfolgreichem switch (build/dry-run aendern System nicht)
                      if [ "$do_gc" -eq 1 ] && [ "$mode" = "switch" ]; then
                        echo "[renix] --- nix GC ---"
                        nix-collect-garbage -d || echo "[renix] (warn) GC failed."
                        if command -v brew >/dev/null 2>&1; then
                          echo "[renix] --- brew cleanup ---"
                          brew cleanup --prune=7 2>/dev/null || true
                        fi
                        if command -v du >/dev/null 2>&1; then
                          echo "[renix] store size:"
                          du -sh /nix/store 2>/dev/null || true
                        fi
                      elif [ "$do_gc" -eq 1 ]; then
                        echo "[renix] GC skipped (mode=$mode, GC nur nach switch)."
                      else
                        echo "[renix] Skipping GC (--no-gc)."
                      fi

                      echo "[renix] Done."
                      exit 0
                    } 2>&1 | tee -a "$log_file"

                    # Exit-Status der LHS aus pipestatus (zsh: lowercase array, 1-indexed)
                    local rc=''${pipestatus[1]:-0}
                    local ended_epoch="$(date +%s)"

                    # Bei Fehler: Logs der fehlgeschlagenen Derivations aus /nix/var/log/nix/drvs/ extrahieren
                    # und ans Run-Log anhaengen. Nur drvs mit >=5 Zeilen Log-Output (Leaf-Failures).
                    if [ "$rc" -ne 0 ]; then
                      {
                        echo ""
                        echo "=== failed derivation logs (auto-extracted) ==="
                      } >> "$log_file"
                      local extract_marker="$state_root/.extract-$$"
                      : > "$extract_marker"
                      grep -oE "/nix/store/[a-z0-9]{32}-[a-zA-Z0-9._+-]+\.drv" "$log_file" 2>/dev/null \
                        | sort -u \
                        | while read -r drv; do
                            [ -e "$drv" ] || continue
                            drv_log="$(nix log "$drv" 2>/dev/null)" || continue
                            [ -z "$drv_log" ] && continue
                            line_count="$(printf '%s\n' "$drv_log" | wc -l | tr -d ' ')"
                            [ "$line_count" -lt 5 ] && continue
                            {
                              echo ""
                              echo "--- $drv ($line_count lines) ---"
                              printf '%s\n' "$drv_log"
                            } >> "$log_file"
                            echo "$drv" >> "$extract_marker"
                          done
                      if [ -s "$extract_marker" ]; then
                        echo "[renix] failed derivation logs appended to: $log_file"
                        echo "[renix] (extracted $(wc -l < "$extract_marker" | tr -d ' ') leaf-failure log(s))"
                      else
                        echo "" >> "$log_file"
                        echo "(no leaf-failure derivation logs found — error likely earlier in pipeline)" >> "$log_file"
                      fi
                      rm -f "$extract_marker"
                    fi

                    # Auto-Rollback: nur wenn ENV-Flag gesetzt, wir geupdated haben, switch-mode, und Fehler auftrat
                    if [ "''${RENIX_AUTOROLLBACK:-0}" = "1" ] && [ "$do_update" -eq 1 ] \
                         && [ "$rc" -ne 0 ] && [ "$mode" = "switch" ] \
                         && [ -f "$lock_dir/flake.lock.$ts" ]; then
                      {
                        echo ""
                        echo "[renix] AUTOROLLBACK: rebuild ($mode) failed after update — restoring pre-update lock"
                      } | tee -a "$log_file"
                      cp "$lock_dir/flake.lock.$ts" "$flake_root/flake.lock"
                      echo "[renix] AUTOROLLBACK: lock restored; run 'renix --no-update' to retry with previous state" | tee -a "$log_file"
                    fi

                    {
                      echo "================="
                      echo "finished: $(date -Iseconds 2>/dev/null || date +%Y-%m-%dT%H:%M:%S%z)"
                      echo "duration: $((ended_epoch - started_epoch))s"
                      echo "exit:     $rc"
                    } >> "$log_file"

                    # Log-Retention
                    ls -1t "$log_dir" 2>/dev/null | tail -n +$((log_retention + 1)) | while read -r old; do
                      rm -f "$log_dir/$old"
                    done

                    return $rc
                  }
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "1password"
        "aliases"
        "alias-finder"
        "brew"
        "colored-man-pages"
        "colorize"
        "common-aliases"
        "copyfile"
        "copypath"
        "cp"
        "extract"
        "fzf"
        "gh"
        "git"
        "git-escape-magic"
        "httpie"
        "macos"
        "magic-enter"
        "mosh"
        "nmap"
        "ssh"
        "sudo"
        "tmux"
        "vscode"
        "web-search"
        "zsh-navigation-tools"
      ];
      theme = ""; # deaktiviert — Starship uebernimmt den Prompt
    };
  };

  # Starship: Catppuccin Mocha, Powerline-Segmente
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      palette = "catppuccin_mocha";

      format = ''[](red)''$os''$username[](bg:peach fg:red)''$directory[](bg:yellow fg:peach)''$git_branch''$git_status[](fg:yellow bg:green)''$c''$rust''$golang''$nodejs''$php''$java''$kotlin''$haskell''$python[](fg:green bg:sapphire)''$conda[](fg:sapphire bg:lavender)''$time[ ](fg:lavender)''$cmd_duration''$line_break''$character'';

      os = {
        disabled = false;
        style = "bg:red fg:crust";
        symbols = {
          Windows = "";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
        };
      };

      username = {
        show_always = true;
        style_user = "bg:red fg:crust";
        style_root = "bg:red fg:crust";
        format = ''[ ''$user](''${style})'';
      };

      directory = {
        style = "bg:peach fg:crust";
        format = ''[ ''$path ](''${style})'';
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = "🎵 ";
          "Pictures" = " ";
          "Developer" = "󰲋 ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:yellow";
        format = ''[[ ''$symbol ''$branch ](fg:crust bg:yellow)]( ''${style} )'';
      };

      git_status = {
        style = "bg:yellow";
        format = ''[[(''${all_status}''${ahead_behind} )](fg:crust bg:yellow)]( ''${style} )'';
      };

      # Sprach-Module (gleiches Format, gruenes Segment)
      nodejs  = { symbol = ""; style = "bg:green"; format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )''; };
      c       = { symbol = " "; style = "bg:green"; format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )''; };
      rust    = { symbol = ""; style = "bg:green"; format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )''; };
      golang  = { symbol = ""; style = "bg:green"; format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )''; };
      php     = { symbol = ""; style = "bg:green"; format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )''; };
      java    = { symbol = " "; style = "bg:green"; format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )''; };
      kotlin  = { symbol = ""; style = "bg:green"; format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )''; };
      haskell = { symbol = ""; style = "bg:green"; format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )''; };
      python  = { symbol = ""; style = "bg:green"; format = ''[[ ''$symbol( ''${version})(\(#''${virtualenv}\)) ](fg:crust bg:green)]( ''${style} )''; };

      conda = {
        symbol = "  ";
        style = "fg:crust bg:sapphire";
        format = ''[''$symbol''${environment} ](''${style})'';
        ignore_base = false;
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:lavender";
        format = ''[[  ''$time ](fg:crust bg:lavender)]( ''${style} )'';
      };

      line_break.disabled = false;

      character = {
        disabled = false;
        success_symbol = "[❯](bold fg:green)";
        error_symbol = "[❯](bold fg:red)";
        vimcmd_symbol = "[❮](bold fg:green)";
        vimcmd_replace_one_symbol = "[❮](bold fg:lavender)";
        vimcmd_replace_symbol = "[❮](bold fg:lavender)";
        vimcmd_visual_symbol = "[❮](bold fg:yellow)";
      };

      cmd_duration = {
        show_milliseconds = true;
        format = " in ''$duration ";
        style = "bg:lavender";
        disabled = false;
        show_notifications = true;
        min_time_to_notify = 45000; # Desktop-Notification ab 45s
      };

      palettes.catppuccin_mocha = colors;
    };
  };
}
