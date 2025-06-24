#!/bin/bash
# Setup dev environment
# Clone repo
git clone git@github.com:smnuman/tmux-dotfiles.git ~/tmux-dotfiles
# Symlink configs
ln -sf ~/tmux-dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/tmux-dotfiles/nvim/init.lua ~/.config/nvim/init.lua
ln -sf ~/tmux-dotfiles/.zshrc ~/.zshrc
ln -sf ~/tmux-dotfiles/iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
# Install Homebrew and tools
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git node python3 fzf ripgrep pyright neovim
# Install tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Install lazy.nvim
rm -rf ~/.local/share/nvim/lazy
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim
# Sync plugins
nvim --headless -c 'lua require("lazy").sync()' -c 'qa'