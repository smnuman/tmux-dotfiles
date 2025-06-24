#!/bin/bash
cp ~/.tmux.conf ~/tmux-dotfiles/tmux.conf
cp ~/.tmux/plugins/tpm/scripts/helpers/tmux_echo_functions.sh ~/tmux-dotfiles/tpm/scripts/helpers/
cd ~/tmux-dotfiles
git add tmux.conf tpm/scripts/helpers/tmux_echo_functions.sh
git commit -m "Sync tmux.conf and TPM scripts $(date)"
git push origin main