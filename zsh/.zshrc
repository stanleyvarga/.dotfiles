#:'#######::'##::::'##:::'##::::'##:'##:::'##:::'########::'######::'##::::'##:
#'##.... ##: ##:::: ##::: ###::'###:. ##:'##::::..... ##::'##... ##: ##:::: ##:
# ##:::: ##: ##:::: ##::: ####'####::. ####::::::::: ##::: ##:::..:: ##:::: ##:
# ##:::: ##: #########::: ## ### ##:::. ##::::::::: ##::::. ######:: #########:
# ##:::: ##: ##.... ##::: ##. #: ##:::: ##:::::::: ##::::::..... ##: ##.... ##:
# ##:::: ##: ##:::: ##::: ##:.:: ##:::: ##::::::: ##::::::'##::: ##: ##:::: ##:
#. #######:: ##:::: ##::: ##:::: ##:::: ##:::::: ########:. ######:: ##:::: ##:
#:.......:::..:::::..::::..:::::..:::::..:::::::........:::......:::..:::::..::

export ZSH="$HOME/.oh-my-zsh"
export DOTFILES="$HOME/.dotfiles"
export LANG=en_US.UTF-8
ZSH_THEME="robbyrussell"

plugins=(
	# Alias related
	you-should-use
	alias-finder
	aliases
	git
	# Package managers
	yarn
	npm
	# Quality of life plugins
	thefuck
	copyfile
	copypath
	zoxide
	timer
	fd-zsh
	zsh-defer
	# Currently not using these, as Warp is handling it 👌
	# zsh-autosuggestions 
	# zsh-syntax-highlighting 
	# safe-paste
	# command-not-found
)
source $ZSH/oh-my-zsh.sh

#:'######::'##::::'##::'######::'########::'#######::'##::::'##:
#'##... ##: ##:::: ##:'##... ##:... ##..::'##.... ##: ###::'###:
# ##:::..:: ##:::: ##: ##:::..::::: ##:::: ##:::: ##: ####'####:
# ##::::::: ##:::: ##:. ######::::: ##:::: ##:::: ##: ## ### ##:
# ##::::::: ##:::: ##::..... ##:::: ##:::: ##:::: ##: ##. #: ##:
# ##::: ##: ##:::: ##:'##::: ##:::: ##:::: ##:::: ##: ##:.:: ##:
#. ######::. #######::. ######::::: ##::::. #######:: ##:::: ##:
#:......::::.......::::......::::::..::::::.......:::..:::::..::
source $DOTFILES/zsh/config/aliases
source $DOTFILES/zsh/config/eval
source $DOTFILES/zsh/config/functions
source $DOTFILES/zsh/config/paths

source $DOTFILES/zsh/plugins/install
source $DOTFILES/zsh/plugins/alias-finder
source $DOTFILES/zsh/plugins/atuin
source $DOTFILES/zsh/plugins/lazy-docker.zsh

source $DOTFILES/zsh/zsh.init
