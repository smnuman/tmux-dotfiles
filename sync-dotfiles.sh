#!/bin/bash
# Sync dotfiles to repo
cp ~/.tmux.conf ~/tmux-dotfiles/.tmux.conf
cp ~/.tmux/plugins/tpm/scripts/helpers/tmux_echo_functions.sh ~/tmux-dotfiles/tpm/scripts/helpers/
cp ~/.config/nvim/init.lua ~/tmux-dotfiles/nvim/init.lua
cp ~/.zshrc ~/tmux-dotfiles/.zshrc
cp ~/Library/Preferences/com.googlecode.iterm2.plist ~/tmux-dotfiles/iterm2.plist
# Change directory to the dotfiles repo
cd ~/tmux-dotfiles
# Add and commit changes
git add .tmux.conf tpm/scripts/helpers/tmux_echo_functions.sh nvim/init.lua .zshrc iterm2.plist
git commit -m "Sync dotfiles $(date)"
git push origin main