# Session-Variablen: Editor, Locale, XDG, Tool-Defaults
{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "bat";

    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    TZ = "Europe/Vienna";

    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    LESS = "-R";
    LESSHISTFILE = "-"; # keine Less-History

    PYTHONUTF8 = "1";
    PYTHONBREAKPOINT = "ipdb.set_trace";

    GOPATH = "$HOME/.local/go";
    CARGO_HOME = "$HOME/.local/cargo";

    HOMEBREW_NO_ANALYTICS = "1";
    MAS_NO_AUTO_INDEX = "1"; # keine Spotlight-Warnungen bei mas upgrade
  };
}
