# ./home/packages.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Shell & Terminal
    atuin
    chroma
    hostmux
    neovim
    nushell
    ranger
    starship
    wezterm
    z-lua
    zellij

    # Development & Tools
    fabric-ai
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
