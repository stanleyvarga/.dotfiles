is_macos() {
  [[ "$(uname)" == "Darwin" ]]
}

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # Install Homebrew

# curl -s https://ohmyposh.dev/install.sh | zsh # Install oh-my-posh
# oh-my-posh font install # Install nerd fonts

echo "🔧 Stowing packages"
stow bin
stow git
stow root

if is_macos; then
  echo "🔧 Installing MacOS packages"
  stow homebrew
	brew bundle --file=~/Brewfile

	stow automac

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
