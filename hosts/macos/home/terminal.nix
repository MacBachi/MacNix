# Terminal-Tools: Tmux, Waveterm, Bat, Eza, Fzf, htop, lf, nix-index
{ config, pkgs, ... }:
let
  colors = config.theme.catppuccin-mocha;
  zshPath = "${pkgs.zsh}/bin/zsh";
  reattachPath = "${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace";
in
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    clock24 = true;
    historyLimit = 9999999;
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
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
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded"

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

      # Variablen (aus zentraler theme.nix)
      CTP_BASE="${colors.base}"
      CTP_SURFACE2="${colors.surface2}"
      CTP_LAVENDER="${colors.lavender}"
      CTP_BLUE="${colors.blue}"
      CTP_GREEN="${colors.green}"
      CTP_YELLOW="${colors.yellow}"
      CTP_RED="${colors.red}"
      CTP_TEXT="${colors.text}"

      # Statusbar-Stil
      set -g status-style "bg=$CTP_BASE,fg=$CTP_TEXT"
      set -g status-position top

      # Fenster-Status
      setw -g window-status-style "fg=$CTP_SURFACE2,bg=$CTP_BASE"
      setw -g window-status-format ' #I #W '

      # Aktuelles Fenster
      setw -g window-status-current-style "fg=$CTP_BASE,bg=$CTP_BLUE,bold"
      setw -g window-status-current-format "#[fg=$CTP_BASE,bg=$CTP_BLUE]#[fg=$CTP_BASE,bg=$CTP_BLUE] #I  #W #[fg=$CTP_BLUE,bg=$CTP_BASE]"

      # Pane-Raender
      set -g pane-active-border-style "fg=$CTP_LAVENDER"
      set -g pane-border-style "fg=$CTP_SURFACE2"

      # Nachrichten
      set -g message-style "fg=$CTP_BASE,bg=$CTP_YELLOW,bold"
      set -g message-command-style "fg=$CTP_BASE,bg=$CTP_YELLOW,bold"

      # --- Statusbar Layout ---
      set -g status-right-length 150
      set -g status-left-length 30

      # Links: MacBachi
      set -g status-left "#[fg=$CTP_BASE,bg=$CTP_RED]#[fg=$CTP_TEXT,bg=$CTP_RED]  MacBachi #[fg=$CTP_RED,bg=$CTP_BASE]"

      # Rechts: CPU/RAM | Zeit | Datum
      set -g status-right "\
        #[fg=$CTP_GREEN,bg=$CTP_BASE]\
        #[fg=$CTP_BASE,bg=$CTP_GREEN]  #(tmux-mem-cpu-load --interval 2)\
        #[fg=$CTP_GREEN,bg=$CTP_BASE]\
        #[fg=$CTP_LAVENDER,bg=$CTP_BASE]\
        #[fg=$CTP_BASE,bg=$CTP_LAVENDER]  %H:%M:%S \
        #[fg=$CTP_LAVENDER,bg=$CTP_BASE]\
        #[fg=$CTP_BLUE,bg=$CTP_BASE]\
        #[fg=$CTP_BASE,bg=$CTP_BLUE]  %Y-%m-%d \
        #[fg=$CTP_BLUE,bg=$CTP_BASE]"

      # Start new session, falls keine vorhanden ist
      new-session -s main
    '';
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
        size = 12;
      };
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

  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  programs.lf.enable = true;
  programs.nix-index.enable = true;

  programs.bat = {
    enable = true;
    config.theme = "Nord";
  };
}
