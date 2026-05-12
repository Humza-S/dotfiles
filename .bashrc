export PATH=$PATH:$HOME/.local/bin

# ===== Git identity (auto-config for new environments) =====
if ! git config --global user.name &> /dev/null; then
  git config --global user.name "Humza"
fi

if ! git config --global user.email &> /dev/null; then
  git config --global user.email "53705839+Humza-S@users.noreply.github.com"
fi

git config --global init.defaultBranch main
if ! command -v oh-my-posh &> /dev/null; then
	curl -s https://ohmyposh.dev/install.sh | bash -s
	export PATH=$PATH:$HOME/.local/bin
fi

# Oh My Posh init
eval "$(oh-my-posh init bash --config ~/.config/omp.json)"
