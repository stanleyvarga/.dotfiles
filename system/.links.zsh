# ZSH
ln -s ~/.dotfiles/.zshrc ~/.zshrc

# VIMRC
ln -s ~/.dotfiles/.vimrc ~/.vimrc

# NVIM
ls -s ~/.dotfiles/nvim/.nvimrc ~/.config/nvim/init.vim

# TMUX
ln -s -f ~/.dotfiles/.tmux/.tmux.conf ~/.tmux.conf
ln -s -f ~/.dotfiles/.tmux/.tmux.conf.local ~/.tmux.conf.local

# VS CODE
ln -s ~/.dotfiles/vscode/settings.json "/Users/$USER/Library/Application Support/Code/User/settings.json"
