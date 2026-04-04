# Git, SSH, GPG und Signing-Konfiguration
{ config, pkgs, ... }:
{
  programs.gpg.enable = true;

  programs.diff-so-fancy = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOeooB06kqRyNbJtis4I6OlqA2DVudcCPNAAjS4Hhw3e";
      signByDefault = true;
    };
    settings = {
      user = {
        name = "MacBachi";
        email = "mac@bachi.at";
      };
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        allowedSignersFile = "${config.home.homeDirectory}/.config/git/allowed_signers";
      };
      init = {
        defaultBranch = "main";
      };
      merge = {
        conflictStyle = "diff3";
        tool = "meld";
      };
      pull = {
        rebase = true;
      };
    };
  };

  home.file.".config/git/allowed_signers" = {
    text = ''
      mac@bachi.at ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOeooB06kqRyNbJtis4I6OlqA2DVudcCPNAAjS4Hhw3e
    '';
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        extraOptions = {
          HashKnownHosts = "yes";
          StrictHostKeyChecking = "ask";
          LogLevel = "ERROR";
          ForwardX11 = "no";
          ForwardAgent = "no";
          IdentityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
        };
      };
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
      };
    };
  };
}
