# tmux-dotfiles: Modern macOS Terminal Environment

This repository contains dotfiles and scripts for a modern development environment on macOS (Apple Silicon/M1+), integrating **tmux**, **iTerm2**, **Neovim**, and a suite of CLI tools. The setup is designed for easy bootstrapping, plugin management, and secure API key handling.

## Features

- **Automated Setup**: Scripts to install, symlink, and sync all configs and plugins.
- **Plugin Management**:
  - [TPM](https://github.com/tmux-plugins/tpm) for tmux plugins
  - [lazy.nvim](https://github.com/folke/lazy.nvim) for Neovim plugins
- **Modern CLI Tools**: fzf, fd, bat, eza, zoxide, ripgrep, etc. (see `Brewfile`)
- **API Key Security**: `.api.keys` managed with git-crypt (see `.gitattributes`)
- **Homebrew Bundle**: All tools managed via `Brewfile`
- **iTerm2 Integration**: Custom preferences in `iterm2.plist`
- **Symlink Strategy**: All configs symlinked from repo for easy version control
- **Zsh Aliases**: All `.zsh_aliases*` files are now organized in the `.zsh_aliases/` folder for better management.

## Folder Structure

- `.tmux.conf` / `tmux.conf` — Tmux configuration
- `.zshrc` — Zsh config (Oh My Zsh, Powerlevel10k, fzf, zoxide, aliases, etc.)
- `.zsh_aliases/` — Folder containing all `.zsh_aliases*` files
- `nvim/init.lua` — Neovim config (lazy.nvim, Treesitter, LSP, Telescope, Dracula theme)
- `tpm/scripts/helpers/tmux_echo_functions.sh` — TPM plugin helper script
- `setup.sh` — One-shot setup: clone, symlink, install tools/plugins
- `sync-dotfiles.sh` — Sync and symlink dotfiles, copy TPM helper, (optionally commit/push)
- `.api.keys` — Example for API key management (encrypted with git-crypt)
- `.homebrewrc` — Homebrew environment settings
- `Brewfile` — Homebrew packages/taps
- `iterm2.plist` — iTerm2 preferences (binary)
- `.gitattributes` — Ensures `.keys` files are encrypted with git-crypt

## Quick Start

1. **Install Homebrew** (if not already):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
2. **Clone this repo**:
   ```bash
   git clone git@github.com:smnuman/tmux-dotfiles.git ~/tmux-dotfiles
   cd ~/tmux-dotfiles
   ```
3. **Run the setup script**:
   ```bash
   ./setup.sh
   ```
   This will symlink configs, install Homebrew tools, TPM, and Neovim plugins.
4. **(Optional) Sync dotfiles later**:
   ```bash
   ./sync-dotfiles.sh
   ```

## Homebrew Bundle
Install all CLI tools and apps listed in `Brewfile`:
```bash
brew bundle --file=~/tmux-dotfiles/Brewfile
```

## Security
- `.api.keys` is encrypted with git-crypt (see `.gitattributes`).
- Never commit secrets in plain text.

## Customization
- Edit `.zshrc` for shell tweaks, aliases, and plugin settings.
- Edit `.zsh_aliases/` for all your zsh aliases and related scripts.
- Edit `nvim/init.lua` for Neovim plugins and LSP setup.
- Edit `tmux.conf` for tmux keybindings and plugins.

---

For more details, see comments in each config file. Contributions and suggestions welcome!
