#:'#######::'##::::'##:::'##::::'##:'##:::'##:::'########::'######::'##::::'##:
#'##.... ##: ##:::: ##::: ###::'###:. ##:'##::::..... ##::'##... ##: ##:::: ##:
# ##:::: ##: ##:::: ##::: ####'####::. ####::::::::: ##::: ##:::..:: ##:::: ##:
# ##:::: ##: #########::: ## ### ##:::. ##::::::::: ##::::. ######:: #########:
# ##:::: ##: ##.... ##::: ##. #: ##:::: ##:::::::: ##::::::..... ##: ##.... ##:
# ##:::: ##: ##:::: ##::: ##:.:: ##:::: ##::::::: ##::::::'##::: ##: ##:::: ##:
#. #######:: ##:::: ##::: ##:::: ##:::: ##:::::: ########:. ######:: ##:::: ##:
#:.......:::..:::::..::::..:::::..:::::..:::::::........:::......:::..:::::..::

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export DOTFILES="$HOME/.dotfiles"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(
	# Alias related
	you-should-use
	alias-finder
	aliases
	git # Aliases for git
	# docker-compose and docker intentionally removed from startup to lazy-load on demand
	# docker-compose # Completion & aliases for docker-compose
	# docker # Completion & aliases for docker
	yarn
	npm
	# Quality of life plugins
	thefuck
	copyfile
	copypath
	zoxide
	timer
	fd-zsh
	# Currently not using these, as Warp is handling it 👌
	# zsh-autosuggestions 
	# zsh-syntax-highlighting 
	# safe-paste
	# command-not-found
)

# You may need to manually set your language environment
export LANG=en_US.UTF-8
source $ZSH/oh-my-zsh.sh

#:'######::'##::::'##::'######::'########::'#######::'##::::'##:
#'##... ##: ##:::: ##:'##... ##:... ##..::'##.... ##: ###::'###:
# ##:::..:: ##:::: ##: ##:::..::::: ##:::: ##:::: ##: ####'####:
# ##::::::: ##:::: ##:. ######::::: ##:::: ##:::: ##: ## ### ##:
# ##::::::: ##:::: ##::..... ##:::: ##:::: ##:::: ##: ##. #: ##:
# ##::: ##: ##:::: ##:'##::: ##:::: ##:::: ##:::: ##: ##:.:: ##:
#. ######::. #######::. ######::::: ##::::. #######:: ##:::: ##:
#:......::::.......::::......::::::..::::::.......:::..:::::..::
# echo "🗄️  SOURCING FILES"
source $DOTFILES/zsh/paths
source $DOTFILES/zsh/aliases
source $DOTFILES/zsh/functions
source $DOTFILES/zsh/plugin-scripts/alias-finder
# Currently not using this as Warp is handling it 👌
# source $DOTFILES/zsh/plugin-scripts/command-not-found.zsh
source $DOTFILES/zsh/eval
source $DOTFILES/zsh/plugin-scripts/atuin
source $DOTFILES/zsh/zsh.init

# Lazy-load docker/docker-compose OMZ plugins moved to plugin-scripts to keep .zshrc minimal
source $DOTFILES/zsh/plugin-scripts/lazy-docker.zsh
