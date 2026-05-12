#!/bin/bash
# install.sh — Dotfiles bootstrap (works in WSL and DevContainers)
#
# VS Code's devcontainer "dotfiles" feature clones your repo to
# ~/.dotfiles and runs this script. Safe to run manually too.
#
# NOTE: We intentionally do NOT use "set -e" (errexit) because the
# oh-my-posh curl install can fail in restricted networks (e.g.
# during devcontainer build) and we don't want that to prevent
# symlinks and git config from completing.

set -o nounset
set -o pipefail

DOTFILES_DIR="${HOME}/.dotfiles"

echo "=== dotfiles install.sh ==="

# ── Helper: symlink with backup ────────────────────────────────────────────
link_file() {
    local src="$1"
    local dst="$2"

    if [ -L "${dst}" ]; then
        rm -f "${dst}"
    elif [ -f "${dst}" ]; then
        echo "-- Backing up ${dst} -> ${dst}.backup"
        mv "${dst}" "${dst}.backup"
    fi

    ln -s "${src}" "${dst}"
    echo "-- Linked ${dst} -> ${src}"
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
# Wrapped in a subshell so a network failure doesn't kill the script.
# In devcontainers, network may not be ready during early lifecycle hooks.
if ! command -v oh-my-posh &>/dev/null; then
    echo "-- oh-my-posh not found, attempting install..."
    if (curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "${HOME}/.local/bin") 2>&1; then
        echo "-- oh-my-posh installed successfully to ~/.local/bin"
    else
        echo "!! oh-my-posh install FAILED (network issue?)"
        echo "!! To install manually, open a terminal and run:"
        echo "!!   curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin"
    fi
else
    echo "-- oh-my-posh already installed: $(which oh-my-posh)"
fi

echo "=== dotfiles install.sh DONE ==="
