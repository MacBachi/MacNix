# ./home/packages.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Shell & Terminal
    atuin # Improved shell history for zsh and others. Syncs history between hosts.
    chroma # syntax highlighting library
    hostmux # connection to multiple SSH hosts by integrating with a terminal multiplexer like Tmux
    nushell # shell that processes data as structured tables (instead of raw text)
    ranger # Console-based two-pane file manager
    starship # customizable, and extremely fast cross-shell prompt
    z-lua # Command line utility that tracks frequently visited directories for quick jumping
    zellij # Terminal workspace and multiplexer
    lftp   # command-line program client for several file transfer protocols.
    # Development & Tools
    fabric-ai # CLI tool for executing pre-defined AI recipes (tasks, utilities)
    gh # Official GitHub CLI tool to manage pull requests, workflows, ..., directly from the terminal.
    jq # Configuration-as-Code data templating tool
    nixfmt-rfc-style # Code formatter for the Nix language
    pipx # Installs and runs Python command-line applications in isolated virtual environments
    rlwrap # Readline wrapper that provides command history, completion, and editing capabilities for any command-line program that lacks these features.

    # CLI Utilities
    aria2 # command-line download utility supporting multi-protocol and multi-source segmented downloads
    autojump # utility that learns visited directories, allowing quick navigation via partial keywords
    broot # terminal file manager
    btop # Resource monitor providing a TUI display of CPU, MEM, disks, network, and running processes.
    colordiff
    cowsay # Prints ASCII animal (default: cow) with user text in a speech bubble.
    duf # Disk Usage/Free utility; modern, colorized alternative to df.
    dust # Disk Usage tree viewer (Rust); intuitive, colored, du alternative.
    fd # Fast, user-friendly file system search; find alternative.
    glances # Cross-platform system monitoring tool; provides a detailed, real-time overview.
    httpie # Human-friendly CLI HTTP client; formatted, colorized JSON support.
    icdiff # Improved, colorized, side-by-side command line diff utility.
    lolcat # Concatenates input (like cat) and applies a rainbow color effect to the text.
    mc # Visual dual-pane file manager for the terminal; a Norton Commander clone.
    procs # Modern ps alternative; colored, human-readable process viewer with extra info.
    progress # Monitors coreutils commands (cp, mv, dd) to display copy percentage and speed.
    pv # Pipe Viewer; monitors data flow through a pipe, showing progress bar, rate, and ETA.
    ripgrep # Fast, recursive regex search tool; respects gitignore, faster than grep.
    ripgrep-all
    tldr # Displays concise, community-driven usage examples for command-line tools.
    tree # Lists contents of directories in a neat, colorized tree-like format.
    unp # Universal shell frontend to unpack many archive formats automatically.
    watch # Repeatedly executes a command, displaying output in full-screen with refresh.
    w3m # Text-based web browser and pager for viewing web pages in the terminal.
    wget # Non-interactive network downloader; retrieves files from HTTP, HTTPS, and FTP servers.
    watchexec # Watches files and runs a command when they change; useful for development workflows.
    sd # Streamlined, fast, and user-friendly alternative to sed for text processing.

    # Networking
    arping # Uses ARP to test if an IP address is in use on the local network.
    cloudflared # CLI suite (Wrangler/cloudflared) for managing Workers, Pages, and Tunnels.
    fping # High-performance tool to send ICMP echo probes to multiple hosts in parallel.
    gping # Ping utility that displays latency in a real-time, terminal-based graph.
    iproute2mac # Replaces standard Linux iproute2 commands with a simplified, macOS-native syntax.
    links2 # Text-based web browser with a full-screen, ncurses interface and optional graphics mode.
    magic-wormhole # Securely transfers files/text between computers using a short, human-pronounceable code.
    masscan # High-speed TCP port scanner; uses asynchronous transmission for large-scale scans.
    mosh # Mobile Shell; remote terminal application offering continuous connectivity and local echo
    mtr # My Traceroute; combines ping and traceroute to provide real-time network path diagnostics.
    ngrok # Creates secure, public URLs for a local web server via a reverse proxy tunnel.
    nmap # Network Mapper; utility for security auditing, network discovery, and port scanning.
    prettyping # Ping wrapper that provides a colorized, and graphical output than standard ping.
    termshark # Wireshark-inspired Terminal User Interface (TUI) for the tshark packet analyzer.

    # Security & Misc
    agg # asciinema gif generator (agg); converts terminal session recordings into animated GIFs.
    asciinema # Records terminal sessions into lightweight, text-based, replayable files (.cast format).
    fortune # Displays a random humorous or poignant aphorism from a database of quotes.
    gnupg # Encrypts, signs, and manages data and communication using the OpenPGP standard.
    lynis # Open-source security auditing tool; performs in-depth system and compliance checks.
    yubikey-manager
    sops # Secret Operations (sops); tool for managing and encrypting secrets in structured files.
    age # Simple, modern, and secure file encryption tool designed to replace GPG for everyday use.
  ];
}
