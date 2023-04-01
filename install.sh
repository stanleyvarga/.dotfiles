stow antigen
stow zsh
stow brew
stow git

brew bundle --file=~/Brewfile
zsh -c "cd zsh && chmod +x ./packages.sh"

## Link VS CODE settings
if [ -f "/Users/$USER/Library/Application Support/Code/User/settings.json" ]; then echo "🗄️  settings.json exists. Skipping symlink"; else ln -s ~/.dotfiles/vscode/settings.json "/Users/$USER/Library/Application Support/Code/User/settings.json"; echo "🗄️ settings.json linked ✅";fi
if [ -f "/Users/$USER/Library/Application Support/Code/User/keybindings.json" ]; then echo "🗄️  keybindings.json exists. Skipping symlink"; else ln -s ~/.dotfiles/vscode/keybindings.json  "/Users/$USER/Library/Application Support/Code/User/keybindings.json"; echo "🗄️ keybindings.json linked ✅";fi
