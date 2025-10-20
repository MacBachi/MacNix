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
    renix = "sudo darwin-rebuild switch --flake $HOME/mynix/hosts/macos#$(scutil --get LocalHostName)";
    flushdns = "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
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
        };
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
      };
    };
  }; 


  # list of programs
  # https://mipmip.github.io/home-manager-option-search

  programs.gpg.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.waveterm = {
    enable = true;
    settings = {
      "app:theme" = "dark";
      "term:fontfamily" = "JetBrains Mono";
      "term:fontsize" = 12;
      "window:opacity" = 0.95;
      "autoupdate:enabled" = false;
      "term:scrollback" = 10000;
      "term:optionasmeta" = true;
      "remote:autossh" = true;
      "telemetry:enabled" = false;
    };
  };


  programs.vscode = {
    enable = true;
    profiles.default = {
      userSettings = {
        "editor.formatOnSave" = true;
        "update.channel" = "none";
        "telemetry.telemetryLevel" = "off";
        "telemetry.enableTelemetry" = false;
        "telemetry.enableCrashReporter" = false;
        "editor.minimap.enabled" = true;
        "editor.wordWrap" = "on";
        "breadcrumbs.enabled" = true;
        "window.zoomlevel" = 0;
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
        eamodio.gitlens
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

  programs.git = {
    enable = true;
    settings = {
      user.email = "mac@bachi.at";
      user.name = "MacBachi";
    };
    lfs.enable = true;
    settings = {
      init.defaultBranch = "main";
      merge = {
        conflictStyle = "diff3";
        tool = "meld";
      };
      pull.rebase = true;
    };
  };

  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  programs.lf.enable = true;

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    clock24 = true;
    historyLimit = 9999999;
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      gruvbox
      sensible
      vim-tmux-navigator
    ];
    extraConfig = ''
      # remap prefix from 'C-b' to 'C-a'
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      # split panes using | and -
      bind | split-window -h
      bind / split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # reload config file
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "~/.config/tmux/tmux.conf reloaded."

      # switch panes using Alt-arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # switch windows using Shift-arrow without prefix
      bind -n S-Left previous-window
      bind -n S-Right next-window

      # don't rename windows automatically
      set-option -g allow-rename off

      # rename window to reflect current program
      setw -g automatic-rename on

      # renumber windows when a window is closed
      set -g renumber-windows on

      # don't do anything when a 'bell' rings
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      # clock mode
      setw -g clock-mode-colour yellow

      # copy mode
      setw -g mode-style 'fg=black bg=yellow bold'

      # panes
      set -g pane-border-style 'fg=yellow'
      set -g pane-active-border-style 'fg=green'

      # statusbar
      set -g status-position top
      set -g status-justify left
      set -g status-style 'fg=green'
      set -g status-left ""
      set -g status-left-length 10
      set -g status-right '#[fg=green,bg=default,bright]#(tmux-mem-cpu-load) #[fg=red,dim,bg=default]#(uptime | cut -f 4-5 -d " " | cut -f 1 -d ",") #[fg=white,bg=default]%a%l:%M:%S %p#[default] #[fg=blue]%Y-%m-%d'

      setw -g window-status-current-style 'fg=black bg=green'
      setw -g window-status-current-format ' #I #W #F '
      setw -g window-status-style 'fg=green bg=black'
      setw -g window-status-format ' #I #[fg=white]#W #[fg=yellow]#F '
      setw -g window-status-bell-style 'fg=black bg=yellow bold'

      # messages
      set -g message-style 'fg=black bg=yellow bold'

      # start new session
      new-session -s main
    '';
  };

  programs.nix-index.enable = true;

  programs.bat = {
    enable = true;
    config.theme = "Nord";
  };

  programs.zoxide.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    extraConfig = ''
      StrictHostKeyChecking no
    '';
    matchBlocks = {
      "*" = {
        extraOptions = {
          LogLevel = "ERROR";
          UserKnownHostsFile = "/dev/null";
        };
      };
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
      };
    };
  };
}
