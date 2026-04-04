# Neovim und VSCode Konfiguration
{ inputs, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    withNodeJs = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      set mouse=a
      set clipboard=unnamed,unnamedplus
      set guicursor=n-v-c-r:block-blink,i:block-blinkwait100-blinkon50-blinkoff50,a:block,sm:block
      set runtimepath+=${pkgs.vimPlugins.nvim-treesitter.withPlugins (p: with p; [ nix python bash lua markdown ])}
    '';

    plugins = with pkgs.vimPlugins; [
      # LSP & Completion
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-vsnip
      luasnip

      # Treesitter
      (nvim-treesitter.withPlugins (p: with p; [
        lua vim vimdoc query
        nix python bash
        markdown markdown_inline
        json yaml dockerfile
      ]))

      # Navigation & UI
      nvim-tree-lua
      telescope-nvim
      plenary-nvim
      (pkgs.vimUtils.buildVimPlugin {
        name = "lualine-nvim";
        src = inputs.lualine-src;
      })
      catppuccin-nvim
      indent-blankline-nvim
      gitsigns-nvim
      dashboard-nvim
      nvim-lint
    ];
    initLua = builtins.readFile ./neovim/init.lua;
  };

  programs.vscode = {
    enable = true;
    profiles.default = {
      userSettings = {
        "editor.fontFamily" = "Fira Code Nerd Font";
        "editor.fontLigatures" = true;
        "workbench.colorTheme" = "Catppuccin Mocha";
        "editor.minimap.side" = "right";
        "terminal.integrated.fontFamily" = "Fira Code Nerd Font";
        "terminal.integrated.fontSize" = 12;
        "editor.formatOnSave" = true;
        "update.channel" = "none";
        "telemetry.telemetryLevel" = "off";
        "telemetry.enableTelemetry" = false;
        "telemetry.enableCrashReporter" = false;
        "editor.minimap.enabled" = true;
        "editor.wordWrap" = "on";
        "breadcrumbs.enabled" = true;
        "window.zoomlevel" = 0;
        "extensions.ignoreRecommendations" = true;
        "workbench.welcomePage.persistence" = "off";
        "workbench.iconTheme" = "vscode-icons";
        "vsicons.dontShowNewVersionMessage" = true;
        "vsicons.dontShowWelcomeMessage" = true;
        "files.exclude" = {
          "**/.github" = true;
          "**/.git" = true;
          "**/.svn" = true;
          "**/.hg" = true;
          "**/CVS" = true;
          "**/.DS_Store" = true;
          "**/Thumbs.db" = true;
          "**/.vscode" = true;
          "**/node_modules" = true;
          "**/dist" = true;
          "**/build" = true;
          "**/.next" = true;
          "**/.nuxt" = true;
          "npm-debug.log*" = true;
          "yarn-error.log*" = true;
          "**/__pycache__" = true;
          "**/*.pyc" = true;
          "**/.venv" = true;
          "**/venv" = true;
          "**/.pytest_cache" = true;
          "**/.mypy_cache" = true;
        };
        "editor.inlineSuggest.enabled" = true;
        "editor.acceptSuggestionOnEnter" = "smart";
        "editor.rulers" = [ 80 100 ];
        "editor.guides.bracketPairs" = true;
        "workbench.startupEditor" = "newUntitledFile";
        "workbench.editor.labelFormat" = "short";
        "explorer.confirmDragAndDrop" = true;
        "editor.scm.diffDecorations" = "overview";
      };
      keybindings = [
        {
          key = "shift+cmd+j";
          command = "workbench.action.focusActiveEditorGroup";
          when = "terminalFocus";
        }
      ];
      extensions = let
        addUnzip = pkg: pkg.overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.unzip ];
        });
        myExtensions = with pkgs.vscode-extensions; [
          catppuccin.catppuccin-vsc
          eamodio.gitlens
          github.copilot
          github.copilot-chat
          github.vscode-pull-request-github
          jnoortheen.nix-ide
          mechatroner.rainbow-csv
          mhutchie.git-graph
          ms-python.debugpy
          ms-python.python
          ms-python.vscode-pylance
          ms-toolsai.jupyter
          ms-toolsai.jupyter-keymap
          ms-toolsai.jupyter-renderers
          ms-toolsai.vscode-jupyter-cell-tags
          ms-toolsai.vscode-jupyter-slideshow
          ms-vscode-remote.remote-ssh
          ms-vscode-remote.remote-ssh-edit
          ms-vscode.remote-explorer
          oderwat.indent-rainbow
          vscode-icons-team.vscode-icons
          yzhang.markdown-all-in-one
        ];
      in
        map addUnzip myExtensions;
    };
  };
}
