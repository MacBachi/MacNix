# ./home/packages.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Shell & Terminal
    atuin       # Improved shell history for zsh and others. Syncs history between hosts.
    chroma      # syntax highlighting library
    hostmux     # connection to multiple SSH hosts by integrating with a terminal multiplexer like Tmux
    # neovim
    nushell     # shell that processes data as structured tables (instead of raw text) 
    ranger      # Console-based two-pane file manager
    starship    # customizable, and extremely fast cross-shell prompt
    z-lua       # Command line utility that tracks frequently visited directories for quick jumping
    zellij      # Terminal workspace and multiplexer

    # Development & Tools
    fabric-ai   # CLI tool for executing pre-defined AI recipes (tasks, utilities)
    gh
    jq
    nixfmt-rfc-style
    ollama
    pipx
    rlwrap

    # CLI Utilities
    aria2
    autojump
    broot
    btop
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
