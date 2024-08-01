# ===-----------------------------------------------------------------------=== 

#:'#######::'##::::'##:::'##::::'##:'##:::'##:::'########::'######::'##::::'##:
#'##.... ##: ##:::: ##::: ###::'###:. ##:'##::::..... ##::'##... ##: ##:::: ##:
# ##:::: ##: ##:::: ##::: ####'####::. ####::::::::: ##::: ##:::..:: ##:::: ##:
# ##:::: ##: #########::: ## ### ##:::. ##::::::::: ##::::. ######:: #########:
# ##:::: ##: ##.... ##::: ##. #: ##:::: ##:::::::: ##::::::..... ##: ##.... ##:
# ##:::: ##: ##:::: ##::: ##:.:: ##:::: ##::::::: ##::::::'##::: ##: ##:::: ##:
#. #######:: ##:::: ##::: ##:::: ##:::: ##:::::: ########:. ######:: ##:::: ##:
#:.......:::..:::::..::::..:::::..:::::..:::::::........:::......:::..:::::..::

# ===-----------------------------------------------------------------------===

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export DOTFILES="$HOME/.dotfiles"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Add wisely, as too many plugins slow down shell startup.

plugins=(
	# Alias related
	you-should-use
	alias-finder
	aliases
	git # Aliases for git
	docker-compose # Completion & aliases for docker-compose
	docker # Completion & aliases for docker
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

# ===--------------------------------------------------------===

#:'######::'##::::'##::'######::'########::'#######::'##::::'##:
#'##... ##: ##:::: ##:'##... ##:... ##..::'##.... ##: ###::'###:
# ##:::..:: ##:::: ##: ##:::..::::: ##:::: ##:::: ##: ####'####:
# ##::::::: ##:::: ##:. ######::::: ##:::: ##:::: ##: ## ### ##:
# ##::::::: ##:::: ##::..... ##:::: ##:::: ##:::: ##: ##. #: ##:
# ##::: ##: ##:::: ##:'##::: ##:::: ##:::: ##:::: ##: ##:.:: ##:
#. ######::. #######::. ######::::: ##::::. #######:: ##:::: ##:
#:......::::.......::::......::::::..::::::.......:::..:::::..::

# ===--------------------------------------------------------===

# echo "🗄️  SOURCING FILES"
source $DOTFILES/zsh/paths
source $DOTFILES/zsh/aliases
source $DOTFILES/zsh/functions

source $DOTFILES/zsh/plugin-scripts/alias-finder

# Currently not using this as Warp is handling it 👌
# source $DOTFILES/zsh/plugin-scripts/command-not-found.zsh
source $DOTFILES/zsh/plugin-scripts/nvm

source $DOTFILES/zsh/eval
source $DOTFILES/zsh/plugin-scripts/atuin
source $DOTFILES/zsh/zsh.init
