is_macos() {
  [[ "$(uname)" == "Darwin" ]]
}

# Check if Oh My Zsh is already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🔧 Installing Oh My Zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # Install Oh My Zsh
else
  echo "✅ Oh My Zsh is already installed"
fi

# curl -s https://ohmyposh.dev/install.sh | zsh # Install oh-my-posh
# oh-my-posh font install # Install nerd fonts

set -e

echo "🔧 Stowing packages"
stow bin
stow git
stow root

if is_macos; then
  echo "🔧 Installing MacOS packages"
  stow --adopt homebrew  # Added --adopt flag to handle existing files
  brew bundle --file=~/Brewfile

  echo "🔧 Setting MacOS defaults"
  chmod +x $DOTFILES/macos/set-defaults
  sh -c "(cd $DOTFILES/macos && ./set-defaults)"
else
  echo "💽 Not running on macOS"
fi

echo "🔧 Installing zsh plugins"
chmod +x $DOTFILES/zsh/plugins
sh -c "(cd $DOTFILES/zsh && ./plugins)"

cat ~/.dotfiles/zsh/.zshrc > ~/.zshrc # Append my custom .zshrc into oh-my-zsh's .zshrc

echo "🔓 GRANTING ACCESS to ~/bin"
chmod +x $HOME/bin/* # Find all files in $HOME/bin and add execute permissions

echo "🎉 Installation complete!"
