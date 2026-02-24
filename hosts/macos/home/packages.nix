# ./home/packages.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hostmux # connection to multiple SSH hosts by integrating with a terminal multiplexer like Tmux
    pkgs.nixfmt # Code formatter for the Nix language
    pipx # Installs and runs Python command-line applications in isolated virtual environments

    # CLI Utilities
    tldr # Displays concise, community-driven usage examples for command-line tools.
    unp # Universal shell frontend to unpack many archive formats automatically.
    w3m # Text-based web browser and pager for viewing web pages in the terminal.
    watchexec # Watches files and runs a command when they change; useful for development workflows.
    sd # Streamlined, fast, and user-friendly alternative to sed for text processing.

    # Networking
    cloudflared # CLI suite (Wrangler/cloudflared) for managing Workers, Pages, and Tunnels.
    iproute2mac # Replaces standard Linux iproute2 commands with a simplified, macOS-native syntax.
    links2 # Text-based web browser with a full-screen, ncurses interface and optional graphics mode.
  ];
}
