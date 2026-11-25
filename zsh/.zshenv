# Loaded for ALL zsh invocations (interactive, non-interactive, scripts, IDEs, agents).
# Keep this file fork-free and minimal.

typeset -gU path PATH fpath FPATH

# macOS Homebrew (Apple Silicon first, Intel fallback)
if [[ $OSTYPE == darwin* ]]; then
  [[ -d /opt/homebrew/bin ]] && path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
  [[ -d /usr/local/bin ]] && path=(/usr/local/bin $path)
fi

# User local binaries (Ubuntu bat/fd shims, starship, zoxide, mise, etc.)
[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)
[[ -d "$HOME/bin" ]] && path=($path "$HOME/bin")

# mise shims: ensures node/npm/npx/ruby/python and global CLIs always work
# without lazy-loading hacks, even in non-interactive shells, IDEs, and agents.
[[ -d "$HOME/.local/share/mise/shims" ]] && path=("$HOME/.local/share/mise/shims" $path)
