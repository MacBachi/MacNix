# ./home/packages.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Shell & Terminal
    atuin       # Improved shell history for zsh and others. Syncs history between hosts.
    chroma      # syntax highlighting library
    hostmux     # connection to multiple SSH hosts by integrating with a terminal multiplexer like Tmux
    nushell     # shell that processes data as structured tables (instead of raw text) 
    ranger      # Console-based two-pane file manager
    starship    # customizable, and extremely fast cross-shell prompt
    z-lua       # Command line utility that tracks frequently visited directories for quick jumping
    zellij      # Terminal workspace and multiplexer

    # Development & Tools
    fabric-ai   # CLI tool for executing pre-defined AI recipes (tasks, utilities)
    gh          # Official GitHub CLI tool to manage pull requests, workflows, ..., directly from the terminal.
    jq          # Configuration-as-Code data templating tool
    nixfmt-rfc-style   # Code formatter for the Nix language
    ollama      # Framework to run large language models (LLMs) locally
    pipx        # Installs and runs Python command-line applications in isolated virtual environments
    rlwrap      # Readline wrapper that provides command history, completion, and editing capabilities for any command-line program that lacks these features.

    # CLI Utilities
    aria2       # command-line download utility supporting multi-protocol and multi-source segmented downloads
    autojump    # utility that learns visited directories, allowing quick navigation via partial keywords
    broot       # terminal file manager
    btop        # Resource monitor providing a TUI display of CPU, MEM, disks, network, and running processes.
    colordiff
    cowsay
    duf
    dust
    fd
    glances
    httpie
    icdiff
    lolcat
    mc
    ncdu
    procs
    progress
    pv
    ripgrep
    ripgrep-all
    tldr
    tree
    unp
    watch
    w3m
    wget

    # Networking
    arping
    cloudflared
    fping
    gping
    iproute2mac
    links2
    magic-wormhole
    masscan
    mosh
    mtr
    ngrok
    nmap
    prettyping
    termshark

    # Security & Misc
    agg
    asciinema
    fortune
    gnupg
    lynis
    yubikey-manager
  ];
}
