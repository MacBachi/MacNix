# ./home/packages.nix
{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Shell & Terminal
    atuin
    chroma
    nushell
    tmux
    hostmux
    zellij
    starship
    wezterm
    neovim
    ranger
    z-lua

    # Development & Tools
    gh
    git
    jq
    ollama
    pipx
    rlwrap
    fabric-ai

    # CLI Utilities
    autojump
    aria2
    broot
    bat
    bat-extras.core
    colordiff
    cowsay
    duf
    dust
    eza
    fd
    fzf
    glances
    htop
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
    wget
    w3m

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
  ];
}
