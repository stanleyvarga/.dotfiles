export DOTFILES="$HOME/.dotfiles"

source "$DOTFILES/antigen/antigen.zsh"
source "$DOTFILES/zsh/.paths"
source "$DOTFILES/zsh/.functions"
source "$DOTFILES/zsh/.aliases"
source "$HOME/.zsh.init" 

# Load plugins, install global packages etc..
zsh -c "cd zsh && chmod +x ./packages.sh"

antigen init "$HOME/.antigenrc"
