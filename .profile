# ~/.profile — managed by ~/.dotfiles

# Source .bashrc for interactive bash shells
if [ -n "${BASH_VERSION:-}" ]; then
    if [ -f "${HOME}/.bashrc" ]; then
        . "${HOME}/.bashrc"
    fi
fi
