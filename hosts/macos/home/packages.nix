# ./home/packages.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hostmux # connection to multiple SSH hosts by integrating with a terminal multiplexer like Tmux
    nixfmt-rfc-style # Code formatter for the Nix language
    pipx # Installs and runs Python command-line applications in isolated virtual environments
    rlwrap # Readline wrapper that provides command history, completion, and editing capabilities for any command-line program that lacks these features.

    # CLI Utilities
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
  ];
}
