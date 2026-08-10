#:'#######::'##::::'##:::'##::::'##:'##:::'##:::'########::'######::'##::::'##:
#'##.... ##: ##:::: ##::: ###::'###:. ##:'##::::..... ##::'##... ##: ##:::: ##:
# ##:::: ##: ##:::: ##::: ####'####::. ####::::::::: ##::: ##:::..:: ##:::: ##:
# ##:::: ##: #########::: ## ### ##:::. ##::::::::: ##::::. ######:: #########:
# ##:::: ##: ##.... ##::: ##. #: ##:::: ##:::::::: ##::::::..... ##: ##.... ##:
# ##:::: ##: ##:::: ##::: ##:.:: ##:::: ##::::::::: ##::::::'##::: ##: ##:::: ##:
#. #######:: ##:::: ##:::: ##:::: ##:::: ##:::::: ########:. ######:: ##:::: ##:
#:.......:::..:::::..::::..:::::..:::::..:::::::........:::......:::..:::::..::

export ZSH="$HOME/.oh-my-zsh"
# DOTFILES: resolve from this file when ~/.zshrc is a symlink into the checkout.
# Fallback: common clone paths (fixes "command not found: l" etc. if detection fails).
if [[ -z "${DOTFILES:-}" || ! -f "${DOTFILES}/zsh/config/aliases" ]]; then
  unset DOTFILES
  _zshrc="${${(%):-%x}:A}"
  if [[ -n "$_zshrc" && -f "${_zshrc:h}/config/aliases" ]]; then
    export DOTFILES="${_zshrc:h:h}"
  else
    for _df in "$HOME/.dotfiles" "$HOME/Documents/dev/.dotfiles" "$HOME/dev/.dotfiles"; do
      [[ -f "$_df/zsh/config/aliases" ]] && export DOTFILES="$_df" && break
    done
  fi
  unset _zshrc _df
fi
[[ -z "${DOTFILES:-}" ]] && export DOTFILES="$HOME/.dotfiles"
export LANG=en_US.UTF-8
ZSH_THEME="robbyrussell"

# Avoid "_main_complete: IFS: restricted" on Tab: bad/inherited IFS or restricted mode breaks the completion system.
unsetopt restricted 2>/dev/null
[[ -n "${IFS+x}" ]] && unset IFS

# --- Fast startup ---
# Skip OMZ upgrade ping + insecure-dir audit (compaudit was a large share of startup).
DISABLE_AUTO_UPDATE=true
DISABLE_UPDATE_PROMPT=true
ZSH_DISABLE_COMPFIX=true

# Cached completions: -C when dump is <24h old; full rebuild (+ zcompile) otherwise.
# Shadows OMZ's compinit call so we keep all plugins without paying full discovery every shell.
autoload -Uz +X compinit
functions[_dotfiles_compinit]=$functions[compinit]
compinit() {
  setopt localoptions extendedglob
  local dump=${ZSH_COMPDUMP:-${ZDOTDIR:-$HOME}/.zcompdump}
  local -a args
  args=("$@")
  integer i=${args[(I)-d]}
  if (( i && i < $#args )); then
    dump=${args[i+1]}
  fi
  if [[ ! -s "$dump" || -n "$dump"(#qN.mh+24) ]]; then
    _dotfiles_compinit -u -d "$dump"
    [[ -s "$dump" ]] && zcompile -U "$dump" 2>/dev/null || true
  else
    _dotfiles_compinit -C -d "$dump"
  fi
}

# zsh-defer first so deferred loaders work. Heavy tools: on-demand wrappers in config/eval.
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

# zstyle for alias-finder must be set before OMZ loads the plugin
# (plugin clones live in install.sh — not re-checked every shell)
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

# Source configs (prefer .zwc when newer — see _dotfiles_source)
_dotfiles_source() {
  local f=$1
  [[ -r $f ]] || return 1
  if [[ ! -s $f.zwc || $f -nt $f.zwc ]]; then
    zcompile -U "$f" 2>/dev/null || true
  fi
  source "$f"
}

_dotfiles_source "$DOTFILES/zsh/config/aliases"
_dotfiles_source "$DOTFILES/zsh/config/eval"
_dotfiles_source "$DOTFILES/zsh/config/functions"
_dotfiles_source "$DOTFILES/zsh/config/paths"
_dotfiles_source "$DOTFILES/zsh/plugins/lazy-docker.zsh"
_dotfiles_source "$DOTFILES/zsh/zsh.init"
unfunction _dotfiles_source 2>/dev/null || true
