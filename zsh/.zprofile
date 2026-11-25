# Login shell setup (runs after /etc/zprofile and ~/.zshenv).

if [[ $OSTYPE == darwin* ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# Re-assert user local bin and mise shims ahead of system/Homebrew paths
# after macOS path_helper and `brew shellenv` prepend to PATH.
typeset -gU path PATH
[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)
[[ -d "$HOME/.local/share/mise/shims" ]] && path=("$HOME/.local/share/mise/shims" $path)
