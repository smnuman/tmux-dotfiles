# tmux-dotfiles

This repository (`git@github.com:smnuman/tmux-dotfiles.git`) contains dotfiles and scripts for a development environment integrating **tmux**, **iTerm2**, and **Neovim** on macOS Sequoia (M1). The setup includes a customized tmux configuration, TPM (Tmux Plugin Manager) tweaks, and a Git-based workflow for version control.

## Current Status

- **iTerm2**: Configured with true-color support, Catppuccin theme, and keybindings for seamless tmux integration.
- **tmux**: Fully integrated with iTerm2, using `~/.tmux.conf` (symlinked to `~/tmux-dotfiles/.tmux.conf`). Plugins include `tpm`, `tmux-sensible`, `vim-tmux-navigator`, `catppuccin-tmux`, and `tmux-yank`.
- **TPM**: `Ctrl-b I` displays "TMUX plugins installed" in the status bar, fixed by modifying `~/.tmux/plugins/tpm/scripts/helpers/tmux_echo_functions.sh` (symlinked to `~/tmux-dotfiles/.tmux.plugins.tpm.scripts.helpers.tmux_echo_functions.sh`).
- **Neovim**: Integrated with `vim-tmux-navigator` for pane navigation (`Ctrl-h/j/k/l`).
- **Git Workflow**: Dotfiles in `~/tmux-dotfiles`, synced via `sync-dotfiles.sh`, with symlinks for `~/.tmux.conf` and TPM scripts.
- **Zsh**: Enhanced with Oh My Zsh, Catppuccin theme, and aliases (e.g., `t` for `tmux`).

## Setup Steps

1. **Install Core Tools**:
   ```bash
   brew install --cask iterm2
   brew install neovim tmux git tree
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```
   - Install JetBrains Mono font for iTerm2.

2. **Configure iTerm2**:
   - Import Catppuccin theme (`Preferences > Profiles > Colors > Color Presets > Import`).
   - Set true-color: `Preferences > Profiles > Terminal > Report Terminal Type: xterm-256color`.
   - Keybindings: `Cmd + T` (new tab), `Cmd + Left/Right` (tab navigation).

3. **Clone Dotfiles Repository**:
   ```bash
   git clone git@github.com:smnuman/tmux-dotfiles.git ~/tmux-dotfiles
   ```

4. **Symlink Dotfiles**:
   ```bash
   ln -sf ~/tmux-dotfiles/.tmux.conf ~/.tmux.conf
   mkdir -p ~/.tmux/plugins/tpm/scripts/helpers
   ln -sf ~/tmux-dotfiles/.tmux.plugins.tpm.scripts.helpers.tmux_echo_functions.sh ~/.tmux/plugins/tpm/scripts/helpers/tmux_echo_functions.sh
   ```

5. **Install TPM**:
   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```

6. **Install tmux Plugins**:
   ```bash
   tmux
   ```
   - Press `Ctrl-b I` to install plugins (`tpm`, `tmux-sensible`, `vim-tmux-navigator`, `catppuccin-tmux`, `tmux-yank`).

7. **Configure Neovim**:
   - Install `lazy.nvim` and `vim-tmux-navigator` plugin:
     ```lua
     { "christoomey/vim-tmux-navigator" }
     ```
     Add to `~/.config/nvim/init.lua` and run `:Lazy sync`.
   - Verify `Ctrl-h/j/k/l` navigation in tmux panes and Neovim splits.

8. **Sync Dotfiles**:
   - Run sync script:
     ```bash
     ~/tmux-dotfiles/sync-dotfiles.sh
     ```
     Contents of `sync-dotfiles.sh`:
     ```bash
     #!/bin/bash
     cd ~/tmux-dotfiles
     git add .tmux.conf .tmux.plugins.tpm.scripts.helpers.tmux_echo_functions.sh
     git commit -m "Sync tmux.conf and TPM scripts $(date)"
     git push origin main
     ```

9. **Setup on Another Machine**:
   ```bash
   git clone git@github.com:smnuman/tmux-dotfiles.git ~/tmux-dotfiles
   ln -sf ~/tmux-dotfiles/.tmux.conf ~/.tmux.conf
   mkdir -p ~/.tmux/plugins/tpm/scripts/helpers
   ln -sf ~/tmux-dotfiles/.tmux.plugins.tpm.scripts.helpers.tmux_echo_functions.sh ~/.tmux/plugins/tpm/scripts/helpers/tmux_echo_functions.sh
   tmux source ~/.tmux.conf
   ```

## Pitfalls and Resolutions

1. **Silent `Ctrl-b I` (No Status Bar Message)**:
   - **Issue**: `Ctrl-b I` showed `TMUX environment reloaded. Done, press ENTER to continue.` in the terminal, not the status bar.
   - **Cause**: `end_message` in `~/.tmux/plugins/tpm/scripts/helpers/tmux_echo_functions.sh` used `tmux_echo` instead of `tmux display-message`.
   - **Fix**: Modified `end_message`:
     ```bash
     end_message() {
         tmux display-message "TMUX plugins installed"
     }
     ```
     Symlinked to `~/tmux-dotfiles/.tmux.plugins.tpm.scripts.helpers.tmux_echo_functions.sh`.
   - **Pitfall**: Initial `sed` edits failed due to mismatched strings; required manual edit after locating the helper script.

2. **Conflicting `Ctrl-k` Binding**:
   - **Issue**: `Ctrl-k` worked but `tmux list-keys | grep C-k` showed a conflicting `root C-k` binding from `vim-tmux-navigator`.
   - **Cause**: `vim-tmux-navigator` re-added default bindings despite `unbind -n C-k`.
   - **Fix**: Added explicit unbindings and custom bindings in `~/.tmux.conf`:
     ```conf
     unbind -n C-h
     unbind -n C-j
     unbind -n C-k
     unbind -n C-l
     set -g @vim-tmux-navigator-keybinding-left 'C-h'
     set -g @vim-tmux-navigator-keybinding-down 'C-j'
     set -g @vim-tmux-navigator-keybinding-up 'C-k'
     set -g @vim-tmux-navigator-keybinding-right 'C-l'
     ```
   - **Pitfall**: Assumed `unbind -n C-k` was sufficient; required overriding plugin defaults.

3. **Dotfile Naming in Git**:
   - **Issue**: Initially copied `~/.tmux.conf` to `~/tmux-dotfiles/tmux.conf`, breaking symlink consistency.
   - **Fix**: Use original filenames (e.g., `~/tmux-dotfiles/.tmux.conf`) to match home directory structure:
     ```bash
     ln -sf ~/tmux-dotfiles/.tmux.conf ~/.tmux.conf
     ```
   - **Pitfall**: Renaming files in `~/tmux-dotfiles` complicated symlinking.

4. **tmux Socket Issues**:
   - **Issue**: Stale tmux sockets caused erratic behavior.
   - **Fix**: Clear sockets before starting tmux:
     ```bash
     tmux kill-server
     rm -rf /tmp/tmux-*
     ```
   - **Pitfall**: Combined commands (`tmux kill-server \rm ...`) failed; required separate execution.

## Extensibility

- **Add tmux Plugins**:
  ```conf
  set -g @plugin 'tmux-plugins/tmux-resurrect'
  set -g @plugin 'tmux-plugins/tmux-continuum'
  set -g @continuum-restore 'on'
  ```
  - Run `Ctrl-b I` and sync:
    ```bash
    ~/tmux-dotfiles/sync-dotfiles.sh
    ```

- **Enhance Neovim**:
  - Add plugins (e.g., `nvim-telescope/telescope.nvim`) to `~/.config/nvim/init.lua`.
  - Sync:
    ```bash
    cp ~/.config/nvim/init.lua ~/tmux-dotfiles/.config.nvim.init.lua
    ~/tmux-dotfiles/sync-dotfiles.sh
    ```

- **iTerm2 Triggers**:
  - Add in `Preferences > Profiles > Advanced > Triggers` (e.g., highlight `ERROR` in red).
  - Export:
    ```bash
    defaults export com.googlecode.iterm2 ~/tmux-dotfiles/.iterm2.plist
    ~/tmux-dotfiles/sync-dotfiles.sh
    ```

- **Zsh Aliases**:
  ```bash
  echo 'alias t="tmux"' >> ~/.zshrc
  cp ~/.zshrc ~/tmux-dotfiles/.zshrc
  ~/tmux-dotfiles/sync-dotfiles.sh
  ```

## Troubleshooting

- **Ctrl-b I Issues**:
  ```bash
  cat ~/.tmux/plugins/tpm/scripts/helpers/tmux_echo_functions.sh | grep "tmux display-message"
  ~/.tmux/plugins/tpm/bin/install_plugins --debug > tpm.log 2>&1
  cat tpm.log
  ```

- **Ctrl-k Issues**:
  ```bash
  tmux list-keys | grep C-k
  nvim -c "map <C-k>" -c "q"
  ```

- **Symlink Verification**:
  ```bash
  ls -l ~/.tmux.conf
  ls -l ~/.tmux/plugins/tpm/scripts/helpers/tmux_echo_functions.sh
  ```

## Notes

- Maintain TPM customizations by reapplying `tmux_echo_functions.sh` edits after TPM updates (`git pull` in `~/.tmux/plugins/tpm`).
- Use `tree ~/.tmux/plugins/tpm` to inspect TPM directory structure.
- Always use original filenames (with dots) in `~/tmux-dotfiles` for consistency (e.g., `.tmux.conf`, not `tmux.conf`).