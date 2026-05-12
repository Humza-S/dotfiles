# ~/.bashrc — managed by ~/.dotfiles
# This file is symlinked by install.sh. Machine-specific overrides
# go in ~/.bashrc.local (which is NOT in git).

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ── PATH ───────────────────────────────────────────────────────────────────
export PATH="${HOME}/.local/bin:${PATH}"

# ── Agency (if installed) ──────────────────────────────────────────────────
if [ -d "${HOME}/.config/agency/CurrentVersion" ]; then
    case ":${PATH}:" in
        *":${HOME}/.config/agency/CurrentVersion:"*) ;;
        *) export PATH="${HOME}/.config/agency/CurrentVersion:${PATH}" ;;
    esac
fi

# ── Oh My Posh prompt ─────────────────────────────────────────────────────
if command -v oh-my-posh &>/dev/null; then
    eval "$(oh-my-posh init bash --config "${HOME}/.config/omp.json")"
fi

# ── History ────────────────────────────────────────────────────────────────
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# ── Aliases ────────────────────────────────────────────────────────────────
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'

# ── Machine-specific overrides (not in git) ────────────────────────────────
if [ -f "${HOME}/.bashrc.local" ]; then
    . "${HOME}/.bashrc.local"
fi
