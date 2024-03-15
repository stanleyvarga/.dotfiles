# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install stow 

stow antigen
stow zsh
stow brew
stow git
stow automac

brew bundle --file=~/Brewfile

# Load plugins, install global packages etc..
# zsh -c "chmod +x ./packages.sh"
source "$DOTFILES/zsh/.packages" 

## Link VS CODE settings
# if [ -f "/Users/$USER/Library/Application Support/Code/User/settings.json" ]; then echo "🗄️  settings.json exists. Skipping symlink"; else ln -s ~/.dotfiles/vscode/settings.json "/Users/$USER/Library/Application Support/Code/User/settings.json"; echo "🗄️ settings.json linked ✅";fi
# if [ -f "/Users/$USER/Library/Application Support/Code/User/keybindings.json" ]; then echo "🗄️  keybindings.json exists. Skipping symlink"; else ln -s ~/.dotfiles/vscode/keybindings.json  "/Users/$USER/Library/Application Support/Code/User/keybindings.json"; echo "🗄️ keybindings.json linked ✅";fi
