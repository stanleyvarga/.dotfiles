zsh -c "cd yarn && chmod +x ./yarn.global.sh"

# eval "$(oh-my-posh init zsh --config $DOTFILES/oh-my-posh/amro.omp.json)"
eval "$(oh-my-posh init zsh --config $DOTFILES/oh-my-posh/robbyrussel.omp.json)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"