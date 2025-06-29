#!/bin/bash
# Sync dotfiles by creating symlinks to repo and copying tmux plugin
set -x # Enable command tracing for verbosity

# Define repo directory
REPO_DIR=~/tmux-dotfiles

# Create symlinks from home directory to repo
ln -sf $REPO_DIR/.tmux.conf ~/.tmux.conf
ln -sf $REPO_DIR/nvim/init.lua ~/.config/nvim/init.lua
ln -sf $REPO_DIR/.zshrc ~/.zshrc
ln -sf $REPO_DIR/iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
ln -sf $REPO_DIR/.api.keys ~/.config/.api.keys
ln -sf $REPO_DIR/.homebrewrc ~/.homebrewrc

# Copy tmux plugin file to avoid modifying plugin directory
mkdir -p $REPO_DIR/tpm/scripts/helpers
cp ~/.tmux/plugins/tpm/scripts/helpers/tmux_echo_functions.sh $REPO_DIR/tpm/scripts/helpers/tmux_echo_functions.sh

# # Change directory to the dotfiles repo
# cd $REPO_DIR

# # Check if *.keys is in .gitattributes; append if not present
# if ! grep -Fx "*.keys filter=git-crypt diff=git-crypt" .gitattributes >/dev/null 2>&1; then
#     echo "*.keys filter=git-crypt diff=git-crypt" >> .gitattributes
# fi

# # Add and commit changes
# git add .tmux.conf tpm/scripts/helpers/tmux_echo_functions.sh nvim/init.lua .zshrc iterm2.plist .api.keys .gitattributes
# git commit -m "Sync dotfiles $(date)" || echo "No changes to commit"
# git push origin main

# Change directory to the dotfiles repo
echo "Changing to repo directory: $REPO_DIR"
cd $REPO_DIR || { echo "Error: Failed to change to $REPO_DIR"; exit 1; }

# Check if *.keys is in .gitattributes; append if not present
echo "Checking .gitattributes for git-crypt rule..."
if ! grep -Fx "*.keys filter=git-crypt diff=git-crypt" .gitattributes >/dev/null 2>&1; then
    echo "Appending *.keys rule to .gitattributes"
    echo "*.keys filter=git-crypt diff=git-crypt" >> .gitattributes || { echo "Error: Failed to update .gitattributes"; exit 1; }
else
    echo "*.keys rule already present in .gitattributes"
fi

# Add and commit changes
echo "Adding files to git..."
git add .tmux.conf tpm/scripts/helpers/tmux_echo_functions.sh nvim/init.lua .zshrc iterm2.plist .api.keys .gitattributes || { echo "Error: Failed to git add"; exit 1; }
echo "Committing changes..."
git commit -m "Sync dotfiles $(date)" || echo "No changes to commit"
echo "Pushing to origin main..."
git push origin main || { echo "Error: Failed to push to origin main"; exit 1; }

echo "Dotfiles sync completed successfully"