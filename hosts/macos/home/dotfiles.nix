# Dotfiles, home.file Eintraege und macOS User-Defaults
{ ... }:
{
  home.shell.enableShellIntegration = true;

  home.shellAliases = {
    top = "btop";
    flushdns = "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder";
    shownix = "find . -type f -name \"*.nix\" -exec echo \"--- FILE: {} ---\" \\; -exec cat {} \\;";
  };

  targets = {
    darwin = {
      defaults = {
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
      };
    };
  };

  home.file.".config/fabric/config.json" = {
    force = true;
    text = builtins.toJSON {
      openai_api_key = "";
      anthropic_api_key = "";
      model = "gpt-4o-mini";
      provider = "openai";
      patterns_directory = "$HOME/.config/fabric/patterns";
      save_path = "$HOME/fabric_sessions";
      ollama_host = "http://localhost:11434";
    };
  };

  home.file.".config/fabric/.env" = {
    force = true;
    text = "";
  };
}
