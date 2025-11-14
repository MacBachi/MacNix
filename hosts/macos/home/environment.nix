# ./home/environment.nix
{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "bat";

    # Locale
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";

    # Zeitzone
    TZ = "Europe/Vienna";

    # XDG Base Dirs
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # Tools
    BAT_THEME = "Nord";
    LESS = "-R";
    LESSHISTFILE = "-";

    # Python
    PYTHONUTF8 = "1";
    PYTHONBREAKPOINT = "ipdb.set_trace";

    # Languages (optional)
    GOPATH = "$HOME/.local/go";
    CARGO_HOME = "$HOME/.local/cargo";

    # Homebrew
    HOMEBREW_NO_ANALYTICS = "1";
  };
}
