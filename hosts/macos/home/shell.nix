# ./home/shell.nix
{
  home,
  ...
}:
{
  home.sessionPath = [
    "/opt/homebrew/bin"
  ];

  programs.bash.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      source /etc/zshrc;

      zstyle ':omz:plugins:alias-finder' autoload yes
      zstyle ':omz:plugins:alias-finder' longer yes
      zstyle ':omz:plugins:alias-finder' exact yes
      zstyle ':omz:plugins:alias-finder' cheaper yes
      MAGIC_ENTER_GIT_COMMAND='git status -u .'
      MAGIC_ENTER_OTHER_COMMAND='ls -lh .'
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "1password"
        "aliases"
        "alias-finder"
        "autopep8"
        "autojump"
        "brew"
        "colored-man-pages"
        "colorize"
        "common-aliases"
        "copyfile"
        "copypath"
        "cp"
        "docker"
        "emotty"
        "encode64"
        "eza"
        "extract"
        "fzf"
        "genpass"
        "gh"
        "git"
        "git-escape-magic"
        "httpie"
        "jump"
        "macos"
        "magic-enter"
        "mosh"
        "nmap"
        "ssh"
        "sudo"
        "tmux"
        "vscode"
        "web-search"
        "z"
        "zsh-navigation-tools"
      ];
      theme = "jonathan";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      palette = "catppuccin_mocha";

      format = ''[](red)''$os''$username[](bg:peach fg:red)''$directory[](bg:yellow fg:peach)''$git_branch''$git_status[](fg:yellow bg:green)''$c''$rust''$golang''$nodejs''$php''$java''$kotlin''$haskell''$python[](fg:green bg:sapphire)''$conda[](fg:sapphire bg:lavender)''$time[ ](fg:lavender)''$cmd_duration''$line_break''$character'';

      # Module
      os = {
        disabled = false;
        style = "bg:red fg:crust";
        symbols = {
          Windows = "";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
        };
      };

      username = {
        show_always = true;
        style_user = "bg:red fg:crust";
        style_root = "bg:red fg:crust";
        format = ''[ ''$user](''${style})'';
      };

      directory = {
        style = "bg:peach fg:crust";
        format = ''[ ''$path ](''${style})'';
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = "🎵 ";
          "Pictures" = " ";
          "Developer" = "󰲋 ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:yellow";
        format = ''[[ ''$symbol ''$branch ](fg:crust bg:yellow)]( ''${style} )'';
      };

      git_status = {
        style = "bg:yellow";
        format = ''[[(''${all_status}''${ahead_behind} )](fg:crust bg:yellow)]( ''${style} )'';
      };

      nodejs = {
        symbol = "";
        style = "bg:green";
        format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )'';
      };

      c = {
        symbol = " ";
        style = "bg:green";
        format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )'';
      };

      rust = {
        symbol = "";
        style = "bg:green";
        format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )'';
      };

      golang = {
        symbol = "";
        style = "bg:green";
        format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )'';
      };

      php = {
        symbol = "";
        style = "bg:green";
        format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )'';
      };

      java = {
        symbol = " ";
        style = "bg:green";
        format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )'';
      };

      kotlin = {
        symbol = "";
        style = "bg:green";
        format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )'';
      };

      haskell = {
        symbol = "";
        style = "bg:green";
        format = ''[[ ''$symbol( ''${version}) ](fg:crust bg:green)]( ''${style} )'';
      };

      python = {
        symbol = "";
        style = "bg:green";
        format = ''[[ ''$symbol( ''${version})(\(#''${virtualenv}\)) ](fg:crust bg:green)]( ''${style} )'';
      };

      conda = {
        symbol = "  ";
        style = "fg:crust bg:sapphire";
        format = ''[''$symbol''${environment} ](''${style})'';
        ignore_base = false;
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:lavender";
        format = ''[[  ''$time ](fg:crust bg:lavender)]( ''${style} )'';
      };

      line_break.disabled = false;

      character = {
        disabled = false;
        success_symbol = "[❯](bold fg:green)";
        error_symbol = "[❯](bold fg:red)";
        vimcmd_symbol = "[❮](bold fg:green)";
        vimcmd_replace_one_symbol = "[❮](bold fg:lavender)";
        vimcmd_replace_symbol = "[❮](bold fg:lavender)";
        vimcmd_visual_symbol = "[❮](bold fg:yellow)";
      };

      cmd_duration = {
        show_milliseconds = true;
        format = " in ''$duration ";
        style = "bg:lavender";
        disabled = false;
        show_notifications = true;
        min_time_to_notify = 45000;
      };

      # Definition der Farbpaletten
      palettes = {
        catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };
      };
    };
  };
}
