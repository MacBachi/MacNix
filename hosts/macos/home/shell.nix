# ./home/shell.nix
{
  home,
  ...
}:
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

    # Declarative history config (replaces manual HIST* exports in initContent)
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
                  source /etc/zshrc;

                  zstyle ':omz:plugins:alias-finder' autoload yes
                  zstyle ':omz:plugins:alias-finder' longer yes
                  zstyle ':omz:plugins:alias-finder' exact yes
                  zstyle ':omz:plugins:alias-finder' cheaper yes
                  MAGIC_ENTER_GIT_COMMAND='git status -u .'
                  MAGIC_ENTER_OTHER_COMMAND='ls -lh .'

                  # Zusätzliche Zsh Optionen (history variables now handled via programs.zsh.history)
                  setopt HIST_IGNORE_DUPS SHARE_HISTORY EXTENDED_GLOB AUTO_CD NO_BEEP \
                         APPEND_HISTORY HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_VERIFY INC_APPEND_HISTORY

                  # Extra ergonomics / safety
                  setopt NO_CLOBBER
                  setopt GLOB_DOTS

                  # Parametrisierbarer Flake-Root
                  : "''${RENIX_FLAKE_ROOT:=$HOME/mynix/hosts/macos}"

                  unalias renix 2>/dev/null || true

                  # rtfm: cheat.sh mit Fallback tldr
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

                  # eza aliases
                  if command -v eza >/dev/null 2>&1; then
                    alias ll='eza -l --git'
                    alias la='eza -la --git'
                    alias lt='eza -lT --git'
                  fi

                  # renix Flags: --no-gc --no-mas --no-rebuild --help
                  renix() {
                    local host="$(scutil --get LocalHostName 2>/dev/null)"
                    local flake="''${RENIX_FLAKE_ROOT}\#''${host}"
                    local do_gc=1
                    local do_mas=1
                    local do_rebuild=1
                    local -a passthru=()

                    for a in "$@"; do
                      case "$a" in
                        --no-gc) do_gc=0 ;;
                        --no-mas) do_mas=0 ;;
                        --no-rebuild) do_rebuild=0 ;;
                        -h|--help)
                          cat <<EOF
      renix [options] [custom rebuild command]
        --no-gc        Skip nix-collect-garbage
        --no-mas       Skip mas upgrade
        --no-rebuild   Skip darwin-rebuild
        --help         Hilfe
      Falls weitere Args (ohne --no-*) übergeben werden, ersetzen sie den Standard-Rebuild.
      ENV: RENIX_FLAKE_ROOT='$RENIX_FLAKE_ROOT'
      EOF
                          return 0
                          ;;
                        --no-*) ;;
                        *) passthru+=("$a") ;;
                      esac
                    done

                    if [ "$do_mas" -eq 1 ] && command -v mas >/dev/null 2>&1; then
                      echo "[renix] mas upgrade…"
                      mas upgrade || echo "[renix] (warn) mas upgrade failed."
                    elif [ "$do_mas" -eq 1 ]; then
                      echo "[renix] mas not installed (skip)."
                    fi

                    local rebuild_cmd="sudo darwin-rebuild switch --flake ''${flake}"
                    if [ "''${#passthru[@]}" -gt 0 ]; then
                      rebuild_cmd="''${passthru[*]}"
                    fi

                    if [ "$do_rebuild" -eq 1 ]; then
                      if ! command -v darwin-rebuild >/dev/null 2>&1; then
                        echo "[renix] darwin-rebuild not found."
                        return 2
                      fi
                      echo "[renix] Running: $rebuild_cmd"
                      if ! eval "$rebuild_cmd"; then
                        echo "[renix] Rebuild failed."
                        return 3
                      fi
                    else
                      echo "[renix] Skipping rebuild (--no-rebuild)."
                    fi

                    if [ "$do_gc" -eq 1 ]; then
                      echo "[renix] Garbage collect…"
                        nix-collect-garbage -d || echo "[renix] (warn) GC failed."
                      if command -v du >/dev/null 2>&1; then
                        echo "[renix] Store size:"
                        du -sh /nix/store 2>/dev/null || true
                      fi
                    else
                      echo "[renix] Skipping GC (--no-gc)."
                    fi

                    echo "[renix] Done."
                  }
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "1password"
        "aliases"
        "alias-finder"
        "autopep8"
        "autojump"
        "brew"
        "colored-man-pages"
        "colorize"
        "common-aliases"
        "copyfile"
        "copypath"
        "cp"
        "docker"
        "emotty"
        "encode64"
        "eza"
        "extract"
        "fzf"
        "genpass"
        "gh"
        "git"
        "git-escape-magic"
        "httpie"
        "jump"
        "macos"
        "magic-enter"
        "mosh"
        "nmap"
        "ssh"
        "sudo"
        "tmux"
        "vscode"
        "web-search"
        "z"
        "zsh-navigation-tools"
      ];
      theme = "jonathan";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      palette = "catppuccin_mocha";

      format = ''[](red)''$os''$username[](bg:peach fg:red)''$directory[](bg:yellow fg:peach)''$git_branch''$git_status[](fg:yellow bg:green)''$c''$rust''$golang''$nodejs''$php''$java''$kotlin''$haskell''$python[](fg:green bg:sapphire)''$conda[](fg:sapphire bg:lavender)''$time[ ](fg:lavender)''$cmd_duration''$line_break''$character'';

      # Module
      os = {
        disabled = false;
        style = "bg:red fg:crust";
        symbols = {
          Windows = "";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          CentOS = "";
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
          "Downloads" = " ";
          "Music" = "🎵 ";
          "Pictures" = " ";
          "Developer" = "󰲋 ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:yellow";
        format = ''[[ ''$symbol ''$branch ](fg:crust bg:yellow)]( ''${style} )'';
      };

      git_status = {
        style = "bg:yellow";
        format = ''[[(''${all_status}''${ahead_behind} )](fg:crust bg:yellow)]( ''${style} )'';
      };

      nodejs = {
        symbol = "";
        style = "bg:green";
        format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )'';
      };

      c = {
        symbol = " ";
        style = "bg:green";
        format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )'';
      };

      rust = {
        symbol = "";
        style = "bg:green";
        format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )'';
      };

      golang = {
        symbol = "";
        style = "bg:green";
        format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )'';
      };

      php = {
        symbol = "";
        style = "bg:green";
        format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )'';
      };

      java = {
        symbol = " ";
        style = "bg:green";
        format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )'';
      };

      kotlin = {
        symbol = "";
        style = "bg:green";
        format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )'';
      };

      haskell = {
        symbol = "";
        style = "bg:green";
        format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )'';
      };

      python = {
        symbol = "";
        style = "bg:green";
        format = ''[[ ''$symbol( ''${version})(\(#''${virtualenv}\)) ](fg:crust bg:green)]( ''${style} )'';
      };

      conda = {
        symbol = "  ";
        style = "fg:crust bg:sapphire";
        format = ''[''$symbol''${environment} ](''${style})'';
        ignore_base = false;
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:lavender";
        format = ''[[  ''$time ](fg:crust bg:lavender)]( ''${style} )'';
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
        format = " in ''$duration ";
        style = "bg:lavender";
        disabled = false;
        show_notifications = true;
        min_time_to_notify = 45000;
      };

      # Definition der Farbpaletten
      palettes = {
        catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };
      };
    };
  };
}
