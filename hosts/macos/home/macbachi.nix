# Home-Manager Programme und Einstellungen für MacBachi
{
  config,
  inputs,
  pkgs,
  lib,
  unstablePkgs,
  ...
}:
{

  home.shell.enableShellIntegration = true;
  home.shellAliases = {
    # aliases. should only be used to manage
    # simple aliases that are compatible across all shells.
    top = "btop";
    flushdns = "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder";
    shownix = "find . -type f -name \"*.nix\" -exec echo \"--- FILE: {} ---\" \\; -exec cat {} \\;";
    l = "eza -i";
    ll = "eza -lgha --icons --group-directories-first";
    vim = "nvim";

  };

  targets = {
    darwin = {
      defaults = {
        "com.apple.Safari" = {
          AutoFillPasswords = false;
          IncludeDevelopMenu = true;
          AutoFillCreditCardData = false;
          AutoOpenSafeDownloads = false;
          ShowOverlayStatusBar = true;
          SpellCheckingEnabled = false;
          GrammarCheckingEnabled = false;
        };
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
      };
    };
  };

  home.file.".config/git/allowed_signers" = {
    text = ''
      mac@bachi.at ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOeooB06kqRyNbJtis4I6OlqA2DVudcCPNAAjS4Hhw3e
    '';
  };

  home.file.".config/fabric/config.json" = {
    force = true;
    text = builtins.toJSON {
      openai_api_key = "";
      anthropic_api_key = "";
      model = "gpt-4o-mini";
      provider = "openai";
      patterns_directory = "$HOME/.config/fabric/patterns";
      save_path = "$HOME/fabric_sessions"; # Speichert die History
      ollama_host = "http://localhost:11434";
    };
  };

  home.file.".config/fabric/.env" = {
    force = true;
    text = "";
  };

  # list of programs
  # https://mipmip.github.io/home-manager-option-search

  programs.gpg.enable = true;

#  programs.direnv = {
#    enable = true;
#   nix-direnv.enable = true;
#  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      set mouse=a
      set clipboard=unnamed,unnamedplus
      set guicursor=n-v-c-r:block-blink,i:block-blinkwait100-blinkon50-blinkoff50,a:block,sm:block
    '';

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-cmp
      nvim-treesitter.withAllGrammars
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-vsnip
      luasnip
      nvim-treesitter.withAllGrammars
      nvim-tree-lua # Moderner Datei-Explorer
      telescope-nvim # Fuzzy Finder für Dateien/Greps/LSPs
      plenary-nvim # Allgemeine Lua-Bibliothek, oft Abhängigkeit
      lualine-nvim # Produktive Statuszeile
      catppuccin-nvim
      indent-blankline-nvim
      gitsigns-nvim
      dashboard-nvim
      nvim-lint
    ];
    extraLuaConfig = builtins.readFile ./neovim/init.lua;
  };

  programs.waveterm = {
    enable = true;
    settings = {
      "app:theme" = "dark";
      "term:fontfamily" = "FiraCode Nerd Font";
      "term:fontsize" = 12;
      "window:opacity" = 0.95;
      "autoupdate:enabled" = false;
      "term:scrollback" = 10000;
      "term:optionasmeta" = true;
      "remote:autossh" = true;
      "telemetry:enabled" = false;

      font = {
        family = "FiraCode Nerd Font";
        size = 12; # Beispiel-Größe
      };
    };
  };

  programs.vscode = {
    enable = true;
    profiles.default = {
      userSettings = {
        "editor.fontFamily" = "Fira Code Nerd Font";
        "editor.fontLigatures" = true;
        "workbench.colorTheme" = "Catppuccin Mocha";
        "editor.minimap.side" = "right";
        "terminal.integrated.fontFamily" = "Fira Code Nerd Font";
        "terminal.integrated.fontSize" = 12;
        "editor.formatOnSave" = true;
        "update.channel" = "none";
        "telemetry.telemetryLevel" = "off";
        "telemetry.enableTelemetry" = false;
        "telemetry.enableCrashReporter" = false;
        "editor.minimap.enabled" = true;
        "editor.wordWrap" = "on";
        "breadcrumbs.enabled" = true;
        "window.zoomlevel" = 0;
        "extensions.ignoreRecommendations" = true;
        "workbench.welcomePage.persistence" = "off";
        "workbench.iconTheme" = "vscode-icons";
        "vsicons.dontShowNewVersionMessage" = true;
        "vsicons.dontShowWelcomeMessage" = true;
        "files.exclude" = {
          # Standard
          "**/.github" = true;
          "**/.git" = true;
          "**/.svn" = true;
          "**/.hg" = true;
          "**/CVS" = true;
          "**/.DS_Store" = true;
          "**/Thumbs.db" = true;
          "**/.vscode" = true;

          # Node.js / JavaScript
          "**/node_modules" = true;
          "**/dist" = true;
          "**/build" = true;
          "**/.next" = true;
          "**/.nuxt" = true;
          "npm-debug.log*" = true;
          "yarn-error.log*" = true;

          # Python
          "**/__pycache__" = true;
          "**/*.pyc" = true;
          "**/.venv" = true;
          "**/venv" = true;
          "**/.pytest_cache" = true;
          "**/.mypy_cache" = true;
        };
        "editor.inlineSuggest.enabled" = true;
        "editor.acceptSuggestionOnEnter" = "smart";
        "editor.rulers" = [
          80
          100
        ];
        "editor.guides.bracketPairs" = true;
        "workbench.startupEditor" = "newUntitledFile";
        "workbench.editor.labelFormat" = "short";
        "explorer.confirmDragAndDrop" = true;
        "editor.scm.diffDecorations" = "overview";
      };
      keybindings = [
        {
          # schnell vom Terminal wieder zum Code springen, ohne die Maus zu benutzen
          key = "shift+cmd+j";
          command = "workbench.action.focusActiveEditorGroup";
          when = "terminalFocus";
        }
      ];
      extensions = with pkgs.vscode-marketplace-release; [
        catppuccin.catppuccin-vsc
        # eamodio.gitlens
        github.copilot
        github.copilot-chat
        github.vscode-pull-request-github
        janisdd.vscode-edit-csv
        jnoortheen.nix-ide
        mechatroner.rainbow-csv
        mhutchie.git-graph
        ms-python.debugpy
        ms-python.python
        ms-python.vscode-pylance
        ms-toolsai.jupyter
        ms-toolsai.jupyter-keymap
        ms-toolsai.jupyter-renderers
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.vscode-jupyter-slideshow
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-ssh-edit
        ms-vscode.remote-explorer
        oderwat.indent-rainbow
        vscode-icons-team.vscode-icons
        yzhang.markdown-all-in-one
        idleberg.applescript
      ];
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
      "--color=auto"
    ];
  };

  programs.fzf.enable = true;
  programs.diff-so-fancy = {
    enable = true;
    enableGitIntegration = true;
  };

  # programs.git = {
  #   enable = true;
  #   settings = {
  #     user.email = "mac@bachi.at";
  #     user.name = "MacBachi";
  #   };
  #   lfs.enable = true;
  #   settings = {
  #     init.defaultBranch = "main";
  #     merge = {
  #       conflictStyle = "diff3";
  #       tool = "meld";
  #     };
  #     pull.rebase = true;
  #   };
  # };

  programs.git = {
    enable = true;
    lfs.enable = true;
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOeooB06kqRyNbJtis4I6OlqA2DVudcCPNAAjS4Hhw3e";
      signByDefault = true;
    };
    settings = {
      user = {
        name = "MacBachi";
        email = "mac@bachi.at";
      };
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        allowedSignersFile = "${config.home.homeDirectory}/.config/git/allowed_signers";
      };
      init = {
        defaultBranch = "main";
      };
      merge = {
        conflictStyle = "diff3";
        tool = "meld";
      };
      pull = {
        rebase = true;
      };
    };
  };

  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  programs.lf.enable = true;

  programs.tmux =
    let
      zshPath = "${pkgs.zsh}/bin/zsh";
      # Für macOS ist reattach-to-user-namespace oft notwendig
      reattachPath = "${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace";
    in
    {
      enable = true;
      keyMode = "vi";
      clock24 = true;
      historyLimit = 9999999;
      mouse = true;
      plugins = with pkgs.tmuxPlugins; [
        gruvbox
        sensible
        vim-tmux-navigator
        resurrect
        yank
      ];
      extraConfig = ''


        # --- Allgemeine Einstellungen ---
             set -g default-shell ${zshPath}
             set -g default-command "${reattachPath} -l ${zshPath}"


             unbind C-b
             set-option -g prefix C-a
             bind-key C-a send-prefix

             set -g status-interval 1
             set -g display-time 4000
             set -g allow-rename off

             # Fenster- und Pane-Splits
             bind v split-window -h -c "#{pane_current_path}"
             bind s split-window -v -c "#{pane_current_path}"
             unbind '"'
             unbind %

             # Konfigurationsdatei neu laden
             bind r source-file ~/.config/tmux/tmux.conf \; display-message "⛩️  tmux.conf reloaded (NixPro Style)"

             # Fenster-Navigation
             bind -n S-Left previous-window
             bind -n S-Right next-window

             # Pane-Navigation
             bind -n M-Left select-pane -L
             bind -n M-Right select-pane -R
             bind -n M-Up select-pane -U
             bind -n M-Down select-pane -D

             # Synchronisation
             bind S set-window-option synchronize-panes

             # --- Farbpalette (Catppuccin Mocha) ---
             set -g default-terminal "tmux-256color"
             set -ag terminal-features ",xterm-256color:RGB"

             # Variablen
             CTP_BASE="#1e1e2e"
             CTP_SURFACE2="#585b70"
             CTP_LAVENDER="#b4befe"
             CTP_BLUE="#89b4fa"
             CTP_GREEN="#a6e3a1"
             CTP_YELLOW="#f9e2af"
             CTP_RED="#f38ba8"
             CTP_TEXT="#cdd6f4"

             # Statusbar-Stil
             set -g status-style "bg=$CTP_BASE,fg=$CTP_TEXT"
             set -g status-position top

             # Fenster-Status
             setw -g window-status-style "fg=$CTP_SURFACE2,bg=$CTP_BASE"
             setw -g window-status-format ' #I #W '

             # Aktuelles Fenster (Blau/Blue)
             setw -g window-status-current-style "fg=$CTP_BASE,bg=$CTP_BLUE,bold"
             setw -g window-status-current-format "#[fg=$CTP_BASE,bg=$CTP_BLUE]#[fg=$CTP_BASE,bg=$CTP_BLUE] #I  #W #[fg=$CTP_BLUE,bg=$CTP_BASE]"

             # Pane-Ränder (Lavender/Surface2)
             set -g pane-active-border-style "fg=$CTP_LAVENDER"
             set -g pane-border-style "fg=$CTP_SURFACE2"

             # Nachrichten (Yellow)
             set -g message-style "fg=$CTP_BASE,bg=$CTP_YELLOW,bold"
             set -g message-command-style "fg=$CTP_BASE,bg=$CTP_YELLOW,bold"

             # --- Statusbar Layout ---
             set -g status-right-length 150
             set -g status-left-length 30
             
             # Links: Sensei/Mac-Info (Rot/Red)
             set -g status-left "#[fg=$CTP_BASE,bg=$CTP_RED]#[fg=$CTP_TEXT,bg=$CTP_RED]  MacBachi #[fg=$CTP_RED,bg=$CTP_BASE]"

             # Rechts: CPU/RAM (Grün) | Zeit (Lavender) | Datum (Blau)
             set -g status-right "\
               #[fg=$CTP_GREEN,bg=$CTP_BASE]\
               #[fg=$CTP_BASE,bg=$CTP_GREEN]  #(tmux-mem-cpu-load --interval 2)\
               #[fg=$CTP_GREEN,bg=$CTP_BASE]\
               #[fg=$CTP_LAVENDER,bg=$CTP_BASE]\
               #[fg=$CTP_BASE,bg=$CTP_LAVENDER]  %H:%M:%S \
               #[fg=$CTP_LAVENDER,bg=$CTP_BASE]\
               #[fg=$CTP_BLUE,bg=$CTP_BASE]\
               #[fg=$CTP_BASE,bg=$CTP_BLUE]  %Y-%m-%d \
               #[fg=$CTP_BLUE,bg=$CTP_BASE]"

             # Start new session, falls keine vorhanden ist
             new-session -s main


      '';
    };

  programs.nix-index.enable = true;

  programs.bat = {
    enable = true;
    config.theme = "Nord";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        extraOptions = {
          HashKnownHosts = "yes";
          StrictHostKeyChecking = "ask";
          LogLevel = "ERROR";
          ForwardX11 = "no";
          ForwardAgent = "no";
          # UserKnownHostsFile = "/dev/null";
          IdentityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
        };
      };
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
      };
    };
  };
}
