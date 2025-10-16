# MacNix ❄️

This is my personal [Nix](https://nixos.org/) configuration for macOS, managed with [nix-darwin](https://github.com/LnL7/nix-darwin) and [Home Manager](https://github.com/nix-community/home-manager). The goal is to create a reproducible, declarative, and consistent development environment.

The project is structured as a [Nix Flake](https://nixos.wiki/wiki/Flakes) to pin dependencies precisely and make the configuration easily shareable and reproducable.

## ✨ Features

- **Reproducible Environment**: Once configured, the exact same environment can be restored on any macOS system.
- **Declarative Package Management**: System and user packages, including Homebrew Casks, are managed centrally in Nix files.
- **Shell**: Configures [Zsh](https://www.zsh.org/) with [Starship](https://starship.rs/) for an informative prompt.
- **Editor**: [Neovim](https://neovim.io/) is pre-configured as the primary code editor.
- **System Tools**: Includes essential tools like `git`, `htop`, and `tmux`, all managed via Nix.
- **Git Configuration**: Global Git settings and aliases are managed directly through Home Manager.

I don't adhere strictly to a declarative-only approach; some applications are installed through Setapp, and I haven't yet been able to integrate their management into Nix.

## 🚀 Installation

Ensure that Nix is installed on your macOS system and that you have enabled Flakes. If not, follow the [official guide](https://nixos.org/download.html).

1.  **Install Nix (following the [official guide](https://nixos.org/download.html)):**
    ```bash
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
    ```

2.  **Install Homebrew (following the [official guide](https://brew.sh)):**
    Homebrew should be installed upfront.
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

3.  **Clone the repository:**
    ```bash
    git clone [https://github.com/MacBachi/MacNix.git](https://github.com/MacBachi/MacNix.git) ~/mynix
    cd ~/mynix
    ```

4.  **Host configuration:**
    This repository uses fixed hostnames. You need to set up a configuration for your Mac.
    Open the `flake.nix` file and add a new entry for your host.

5.  **Build the system for the first time:**
    ```bash
    sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
    sudo mv /etc/zshrc /etc/zhsrc.before-nix-darwin
    ```

    ```bash
    sudo nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake $HOME/mynix/hosts/macos
    ```
## ♻️ Rebuild

After changing the configuration, the system has to be rebuilt.

``` bash
sudo darwin-rebuild switch --flake $HOME/mynix/hosts/macos#$(scutil --get LocalHostName)
```
## 🛠️ Updating the System

To update the system and all packages (Nix & Homebrew) to their latest versions, run the following commands. 

1.  **Update flake inputs:**
    ```bash
    nix flake update --flake $HOME/mynix/hosts/macos
    ```
2.  **Apply the new configuration:**
    ```bash
    sudo darwin-rebuild switch --flake $HOME/mynix/hosts/macos#$(scutil --get LocalHostName)
    ```

## 💾 Freeing Up Disk Space

Checking Nix Disk Space Usage:
```bash
du -sh /nix/store
```

To remove old, unused Nix generations and packages, perform a garbage collection:
```bash
nix-collect-garbage -d
```
