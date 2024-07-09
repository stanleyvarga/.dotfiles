export DOTFILES="$HOME/.dotfiles"

source "$DOTFILES/antigen/antigen.zsh"
source "$DOTFILES/zsh/.paths"
source "$DOTFILES/zsh/.functions"
source "$DOTFILES/zsh/.aliases"
source "$DOTFILES/zsh/.eval"
source "$HOME/.zsh.init" 



antigen init "$HOME/.antigenrc"
