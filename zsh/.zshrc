#:'#######:::'######::'##::::'##:'########:::'######::
#'##.... ##:'##... ##: ##:::: ##: ##.... ##:'##... ##:
#..::::: ##: ##:::..:: ##:::: ##: ##:::: ##: ##:::..::
#:'#######::. ######:: #########: ########:: ##:::::::
#:'##::::::::..... ##: ##.... ##: ##.. ##::: ##:::::::
#: ##:::::::'##::: ##: ##:::: ##: ##::. ##:: ##::: ##:
#: ########:. ######:: ##:::: ##: ##:::. ##:. ######::
#:........:::......:::..:::::..::..:::::..:::......:::

# Resolve DOTFILES from this file when ~/.zshrc is a symlink into the checkout.
if [[ -z "${DOTFILES:-}" || ! -f "${DOTFILES}/zsh/config/aliases" ]]; then
  unset DOTFILES
  _zshrc="${${(%):-%x}:A}"
  if [[ -n "$_zshrc" && -f "${_zshrc:h}/config/aliases" ]]; then
    export DOTFILES="${_zshrc:h:h}"
  else
    for _df in "$HOME/.dotfiles" "$HOME/Documents/OS/.dotfiles" "$HOME/Documents/dev/.dotfiles" "$HOME/dev/.dotfiles"; do
      [[ -f "$_df/zsh/config/aliases" ]] && export DOTFILES="$_df" && break
    done
  fi
  unset _zshrc _df
fi
[[ -z "${DOTFILES:-}" ]] && export DOTFILES="$HOME/.dotfiles"

export LANG=en_US.UTF-8
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Avoid "_main_complete: IFS: restricted" on Tab from bad inherited IFS.
unsetopt restricted 2>/dev/null
[[ -n "${IFS+x}" ]] && unset IFS

# Source helper (compiles .zwc transparently when missing or stale)
_dotfiles_source() {
  local f=$1
  [[ -r $f ]] || return 1
  if [[ ! -s $f.zwc || $f -nt $f.zwc ]]; then
    zcompile -U "$f" 2>/dev/null || true
  fi
  source "$f"
}

# 1. Core options, keybindings, and paths first (sets PATH + FPATH)
_dotfiles_source "$DOTFILES/zsh/config/options"
_dotfiles_source "$DOTFILES/zsh/config/paths"

# 2. Antidote static plugin bundle (rebuilt only when zsh_plugins.txt changes)
_zsh_cache="$XDG_CACHE_HOME/zsh"
_antidote_txt="$DOTFILES/zsh/zsh_plugins.txt"
_antidote_zsh="$_zsh_cache/zsh_plugins.zsh"
if [[ -r "$HOME/.antidote/antidote.zsh" ]]; then
  if [[ ! -s "$_antidote_zsh" || "$_antidote_txt" -nt "$_antidote_zsh" ]]; then
    mkdir -p "$_zsh_cache"
    source "$HOME/.antidote/antidote.zsh"
    antidote bundle <"$_antidote_txt" >|"$_antidote_zsh"
    zcompile -U "$_antidote_zsh" 2>/dev/null || true
  fi
  source "$_antidote_zsh"
fi
unset _antidote_txt _antidote_zsh

# 3. Cached completions: -C when dump is <24h old; full rebuild + zcompile otherwise
autoload -Uz compinit
() {
  setopt localoptions extendedglob
  local dump="$_zsh_cache/zcompdump-${HOST%%.*}-${ZSH_VERSION}"
  mkdir -p "$_zsh_cache"
  if [[ ! -s "$dump" || -n "$dump"(#qN.mh+24) ]]; then
    compinit -u -d "$dump"
    [[ -s "$dump" ]] && zcompile -U "$dump" 2>/dev/null || true
  else
    compinit -C -d "$dump"
  fi
}
unset _zsh_cache

# 4. Aliases, cached tool inits (starship, mise, zoxide, wt, fzf, atuin), functions, banner
_dotfiles_source "$DOTFILES/zsh/config/aliases"
_dotfiles_source "$DOTFILES/zsh/config/eval"
_dotfiles_source "$DOTFILES/zsh/config/functions"
_dotfiles_source "$DOTFILES/zsh/zsh.init"

unfunction _dotfiles_source 2>/dev/null || true
