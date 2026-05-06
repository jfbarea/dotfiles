#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NVIM_CONFIG_DIR="$HOME/.config/nvim"

echo "==> Installing Neovim config from $SCRIPT_DIR/nvim"

# Required tools
command -v nvim >/dev/null 2>&1 || { echo "ERROR: neovim is not installed (brew install neovim)"; exit 1; }
command -v git  >/dev/null 2>&1 || { echo "ERROR: git is not installed"; exit 1; }

# Recommended (warn only)
command -v rg >/dev/null 2>&1 || echo "WARN: ripgrep not installed (brew install ripgrep) — Telescope live_grep won't work"
command -v fd >/dev/null 2>&1 || echo "WARN: fd not installed (brew install fd) — Telescope find_files will be slower"

# Backup existing config if it's a real directory (not a symlink)
if [ -e "$NVIM_CONFIG_DIR" ] && [ ! -L "$NVIM_CONFIG_DIR" ]; then
  BACKUP="${NVIM_CONFIG_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
  echo "==> Backing up existing config to $BACKUP"
  mv "$NVIM_CONFIG_DIR" "$BACKUP"
elif [ -L "$NVIM_CONFIG_DIR" ]; then
  echo "==> Removing existing symlink"
  rm "$NVIM_CONFIG_DIR"
fi

mkdir -p "$(dirname "$NVIM_CONFIG_DIR")"
ln -s "$SCRIPT_DIR/nvim" "$NVIM_CONFIG_DIR"

echo "==> Done. Run 'nvim' — lazy.nvim will install plugins on first launch."
