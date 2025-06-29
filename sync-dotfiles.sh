#!/bin/bash
# Sync dotfiles by creating symlinks to repo and copying tmux plugin
# Define repo directory
REPO_DIR=~/tmux-dotfiles

# Create symlinks from home directory to repo
ln -sf $REPO_DIR/.tmux.conf ~/.tmux.conf
ln -sf $REPO_DIR/nvim/init.lua ~/.config/nvim/init.lua
ln -sf $REPO_DIR/.zshrc ~/.zshrc
ln -sf $REPO_DIR/iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
ln -sf $REPO_DIR/.api.keys ~/.config./.api.keys

# Copy tmux plugin file to avoid modifying plugin directory
mkdir -p $REPO_DIR/tpm/scripts/helpers
cp ~/.tmux/plugins/tpm/scripts/helpers/tmux_echo_functions.sh $REPO_DIR/tpm/scripts/helpers/tmux_echo_functions.sh

# Change directory to the dotfiles repo
cd $REPO_DIR

# Update .gitattributes for git-crypt
echo "*.keys filter=git-crypt diff=git-crypt" > .gitattributes

# Add and commit changes
git add .tmux.conf tpm/scripts/helpers/tmux_echo_functions.sh nvim/init.lua .zshrc iterm2.plist .api.keys .gitattributes
git commit -m "Sync dotfiles $(date)" || echo "No changes to commit"
git push origin main