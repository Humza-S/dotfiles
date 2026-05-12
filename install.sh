#!/bin/bash
# install.sh — Dotfiles bootstrap (works in WSL and DevContainers)
#
# VS Code's devcontainer "dotfiles" feature clones your repo to
# ~/.dotfiles and runs this script. It's also safe to run manually.

set -o errexit
set -o nounset
set -o pipefail

DOTFILES_DIR="${HOME}/.dotfiles"

echo "=== dotfiles install.sh ==="

# ── Helper: symlink with backup ────────────────────────────────────────────
link_file() {
    local src="$1"
    local dst="$2"

    if [ -L "${dst}" ]; then
        # Already a symlink — remove and re-create
        rm -f "${dst}"
    elif [ -f "${dst}" ]; then
        # Regular file — back it up
        echo "-- Backing up ${dst} -> ${dst}.backup"
        mv "${dst}" "${dst}.backup"
    fi

    ln -s "${src}" "${dst}"
    echo "-- Linked ${src} -> ${dst}"
}

# ── Symlink dotfiles ───────────────────────────────────────────────────────
link_file "${DOTFILES_DIR}/.bashrc"  "${HOME}/.bashrc"
link_file "${DOTFILES_DIR}/.profile" "${HOME}/.profile"

mkdir -p "${HOME}/.config"
link_file "${DOTFILES_DIR}/.config/omp.json" "${HOME}/.config/omp.json"

# ── Git identity (only if not already set) ─────────────────────────────────
if ! git config --global user.name &>/dev/null; then
    git config --global user.name "Humza"
    echo "-- Set git user.name"
fi

if ! git config --global user.email &>/dev/null; then
    git config --global user.email "53705839+Humza-S@users.noreply.github.com"
    echo "-- Set git user.email"
fi

git config --global init.defaultBranch main

# ── Install oh-my-posh (if not already present) ───────────────────────────
if ! command -v oh-my-posh &>/dev/null; then
    echo "-- Installing oh-my-posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "${HOME}/.local/bin"
    export PATH="${HOME}/.local/bin:${PATH}"
    echo "-- oh-my-posh installed to ~/.local/bin"
else
    echo "-- oh-my-posh already installed: $(which oh-my-posh)"
fi

echo "=== dotfiles install.sh DONE ==="
