#:'#######::'##::::'##:::'##::::'##:'##:::'##:::'########::'######::'##::::'##:
#'##.... ##: ##:::: ##::: ###::'###:. ##:'##::::..... ##::'##... ##: ##:::: ##:
# ##:::: ##: ##:::: ##::: ####'####::. ####::::::::: ##::: ##:::..:: ##:::: ##:
# ##:::: ##: #########::: ## ### ##:::. ##::::::::: ##::::. ######:: #########:
# ##:::: ##: ##.... ##::: ##. #: ##:::: ##:::::::: ##::::::..... ##: ##.... ##:
# ##:::: ##: ##:::: ##::: ##:.:: ##:::: ##::::::::: ##::::::'##::: ##: ##:::: ##:
#. #######:: ##:::: ##:::: ##:::: ##:::: ##:::::: ########:. ######:: ##:::: ##:
#:.......:::..:::::..::::..:::::..:::::..:::::::........:::......:::..:::::..::

export ZSH="$HOME/.oh-my-zsh"
# DOTFILES: install.sh prepends export DOTFILES="..." to ~/.zshrc. If that line is missing or wrong,
# find a checkout that contains zsh/config/aliases (fixes "command not found: l" etc.).
if [[ -z "${DOTFILES:-}" || ! -f "${DOTFILES}/zsh/config/aliases" ]]; then
  unset DOTFILES
  for _df in "$HOME/.dotfiles" "$HOME/Documents/dev/.dotfiles" "$HOME/dev/.dotfiles"; do
    [[ -f "$_df/zsh/config/aliases" ]] && export DOTFILES="$_df" && break
  done
  unset _df
fi
[[ -z "${DOTFILES:-}" ]] && export DOTFILES="$HOME/.dotfiles"
export LANG=en_US.UTF-8
ZSH_THEME="robbyrussell"

# Avoid "_main_complete: IFS: restricted" on Tab: bad/inherited IFS or restricted mode breaks the completion system.
unsetopt restricted 2>/dev/null
[[ -n "${IFS+x}" ]] && unset IFS

# zsh-defer first so deferred loaders in config/eval work. Heavy tools load via config/eval (zoxide, thefuck, atuin).
plugins=(
	zsh-defer
	you-should-use
	alias-finder
	aliases
	git
	copyfile
	copypath
	fd-zsh
	zsh-autosuggestions
	zsh-syntax-highlighting
)

# Clone third-party OMZ plugins before oh-my-zsh.sh so first shell finds them.
source "$DOTFILES/zsh/plugins/install"
# zstyle for alias-finder must be set before OMZ loads the plugin
source "$DOTFILES/zsh/plugins/alias-finder"
source "$ZSH/oh-my-zsh.sh"

#:'######::'##::::'##::'######::'########::'#######::'##::::'##:
#'##... ##: ##:::: ##:'##... ##:... ##..::'##.... ##: ###::'###:
# ##:::..:: ##:::: ##: ##:::..::::: ##:::: ##:::: ##: ####'####:
# ##::::::: ##:::: ##:. ######::::: ##:::: ##:::: ##: ## ### ##:
# ##::::::: ##:::: ##::..... ##:::: ##:::: ##:::: ##: ##. #: ##:
# ##::: ##: ##:::: ##:'##::: ##:::: ##:::: ##:::: ##: ##:.:: ##:
#. ######::. #######::. ######::::: ##::::. #######:: ##:::: ##:
#:......::::.......::::......::::::..::::::.......:::..:::::..::
source "$DOTFILES/zsh/config/aliases"
source "$DOTFILES/zsh/config/eval"
source "$DOTFILES/zsh/config/functions"
source "$DOTFILES/zsh/config/paths"

source "$DOTFILES/zsh/plugins/lazy-docker.zsh"

source "$DOTFILES/zsh/zsh.init"
