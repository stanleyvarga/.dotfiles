export DOTFILES="$HOME/.dotfiles"
source "$DOTFILES/antigen/antigen.zsh"
source "$DOTFILES/zsh/.paths"
source "$DOTFILES/zsh/.functions"
source "$DOTFILES/zsh/.aliases"
source "$DOTFILES/zsh/.eval"
source "$HOME/.zsh.init" 

# Load plugins, install global packages etc..
# zsh -c "chmod +x ./packages.sh"
source "$DOTFILES/zsh/.packages" 

antigen init "$HOME/.antigenrc"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
