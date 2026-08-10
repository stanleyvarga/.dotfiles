#!/usr/bin/env bash
# Clone anywhere, run ./install.sh — symlinks configs (no stow), bootstraps OS tools.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES

is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }
is_linux() { [[ "$(uname -s)" == "Linux" ]]; }
has_apt() { command -v apt-get >/dev/null 2>&1; }

link_file() {
  local src=$1 dest=$2
  mkdir -p "$(dirname "$dest")"
  ln -sf "$src" "$dest"
}

link_dir_contents() {
  local src_dir=$1 dest_dir=$2
  mkdir -p "$dest_dir"
  local src_real dest_real
  src_real=$(cd "$src_dir" && pwd -P)
  dest_real=$(cd "$dest_dir" && pwd -P)
  if [[ "$src_real" == "$dest_real" ]]; then
    echo "⚠️  Refusing to link $src_dir into itself via $dest_dir (would replace scripts with self-symlinks)"
    return 1
  fi
  local f
  shopt -s nullglob
  for f in "$src_dir"/*; do
    [[ -e "$f" || -L "$f" ]] || continue
    ln -sf "$f" "$dest_dir/$(basename "$f")"
  done
  shopt -u nullglob
}

symlink_dotfiles() {
  echo "🔗 Linking bin, git, root"
  link_dir_contents "$DOTFILES/bin/bin" "$HOME/bin"
  link_file "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
  link_file "$DOTFILES/root/.sleep" "$HOME/.sleep"
  link_file "$DOTFILES/root/.wakeup" "$HOME/.wakeup"
  if is_macos; then
    echo "🔗 Linking Homebrew files"
    link_file "$DOTFILES/homebrew/Brewfile" "$HOME/Brewfile"
    if [[ -f "$DOTFILES/homebrew/Brewfile.lock.json" ]]; then
      link_file "$DOTFILES/homebrew/Brewfile.lock.json" "$HOME/Brewfile.lock.json"
    fi
  fi
}

ensure_linux_basics() {
  if ! is_linux || ! has_apt; then
    return 0
  fi
  echo "🔧 Installing Linux prerequisites (git, curl, zsh, eza)"
  sudo apt-get update
  sudo apt-get install -y git curl zsh eza unzip
  if [[ "${INSTALL_LINUX_EXTRAS:-1}" != "0" ]]; then
    echo "🔧 Installing Linux CLI tools (bat, fd-find, fzf, jq)"
    sudo apt-get install -y bat fd-find fzf jq
  fi
}

ensure_bun_linux() {
  if ! is_linux; then
    return 0
  fi
  if command -v bun >/dev/null 2>&1; then
    echo "✅ bun is already installed"
    return 0
  fi
  if ! command -v curl >/dev/null 2>&1; then
    echo "⚠️  curl not found; install curl then re-run install.sh for bun"
    return 0
  fi
  if ! command -v unzip >/dev/null 2>&1; then
    echo "⚠️  unzip not found (required by bun); install unzip then re-run install.sh for bun"
    return 0
  fi
  echo "🔧 Installing bun (https://bun.sh)"
  # Prefer zsh so the installer's optional rc snippets match your login shell.
  curl -fsSL https://bun.sh/install | SHELL="${SHELL:-/bin/zsh}" bash
  if [[ -x "${HOME}/.bun/bin/bun" ]]; then
    echo "💡 bun is on disk. This terminal's PATH is unchanged until you run: source ~/.zshrc  (or open a new tab)"
  fi
}

ensure_homebrew() {
  if ! is_macos; then
    return 0
  fi
  if command -v brew >/dev/null 2>&1; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
    return 0
  fi
  echo "🔧 Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_oh_my_zsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo "✅ Oh My Zsh is already installed"
    return 0
  fi
  echo "🔧 Installing Oh My Zsh"
  # Non-interactive defaults: no zsh at end, no chsh, no prompt hang on .zshrc overwrite
  export RUNZSH=no CHSH=no OVERWRITE_CONFIRMATION=no
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

run_macos_bundle_and_defaults() {
  if ! is_macos; then
    echo "💽 Not running on macOS — skipping Homebrew bundle and defaults"
    return 0
  fi
  ensure_homebrew
  if [[ "${SKIP_BREW_BUNDLE:-}" == "1" ]]; then
    echo "⏭️  SKIP_BREW_BUNDLE=1 — skipping brew bundle"
  else
    echo "🔧 Installing macOS packages (brew bundle)"
    brew bundle --file="$DOTFILES/homebrew/Brewfile"
  fi
  echo "🔧 Setting macOS defaults"
  chmod +x "$DOTFILES/macos/set-defaults"
  (cd "$DOTFILES/macos" && ./set-defaults)
}

install_zsh_plugin_repos() {
  echo "🔧 Installing Oh My Zsh custom plugin repos"
  chmod +x "$DOTFILES/zsh/plugins/install"
  bash "$DOTFILES/zsh/plugins/install"
}

link_zshrc() {
  echo "🔗 Linking ~/.zshrc → $DOTFILES/zsh/.zshrc"
  link_file "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
}

# Cursor/VS Code zsh shell integration sources $USER_ZDOTDIR/.zshrc before normal startup
# (see shellIntegration-rc.zsh). If USER_ZDOTDIR is unset, that path is wrong and ~/.zshrc
# never runs — you get no aliases/Omz (bare hostname% prompt).
ensure_user_zdotdir_for_ide_terminals() {
  if is_linux; then
    mkdir -p "$HOME/.config/environment.d"
    printf 'USER_ZDOTDIR=%s\n' "$HOME" >"$HOME/.config/environment.d/99-dotfiles-user-zdotdir.conf"
    echo "📝 Wrote ~/.config/environment.d/99-dotfiles-user-zdotdir.conf (USER_ZDOTDIR=$HOME)"
    echo "   Restart Cursor/your session so integrated terminals inherit USER_ZDOTDIR."
  fi
}

# vscode/ is a reference snapshot only — not auto-linked (live Cursor/Code User settings
# are usually newer). See README "VS Code / Cursor".
note_vscode_reference() {
  if [[ -d "$DOTFILES/vscode" ]]; then
    echo "💡 vscode/ is reference-only (not linked). Copy manually if you want those settings."
  fi
}

chmod_home_bin() {
  echo "🔓 Granting execute permission to ~/bin"
  shopt -s nullglob
  local f
  for f in "$HOME"/bin/*; do
    [[ -f "$f" ]] && chmod +x "$f"
  done
  shopt -u nullglob
}

get_login_shell() {
  if is_macos; then
    dscl . -read "/Users/$(id -un)" UserShell 2>/dev/null | awk '{print $2}'
  else
    getent passwd "$(id -un)" 2>/dev/null | cut -d: -f7
  fi
}

login_shell_is_zsh() {
  local cur
  cur=$(get_login_shell)
  [[ -n "$cur" && "$(basename "$cur")" == "zsh" ]]
}

ensure_zsh_in_etc_shells() {
  local zsh_path=$1
  if grep -qxF "$zsh_path" /etc/shells 2>/dev/null; then
    return 0
  fi
  echo "🔧 Adding $zsh_path to /etc/shells (sudo)"
  if ! echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null; then
    echo "⚠️  Could not append to /etc/shells; chsh may refuse this zsh path"
    return 1
  fi
}

set_zsh_as_login_shell() {
  if [[ "${SKIP_CHSH:-}" == "1" ]]; then
    echo "⏭️  SKIP_CHSH=1 — leaving login shell unchanged"
    return 0
  fi
  local zsh_path
  zsh_path="$(command -v zsh 2>/dev/null)" || true
  if [[ -z "$zsh_path" || ! -x "$zsh_path" ]]; then
    echo "⚠️  zsh not found in PATH; cannot set login shell"
    return 0
  fi
  if login_shell_is_zsh; then
    echo "✅ zsh is already the login shell ($zsh_path)"
    return 0
  fi
  ensure_zsh_in_etc_shells "$zsh_path" || true
  echo "🔧 Setting zsh as login shell (your account password may be required)"
  if chsh -s "$zsh_path"; then
    echo "✅ Login shell set to $zsh_path — open a new terminal or log out and back in"
  else
    echo "⚠️  chsh failed (no TTY or permissions). Run manually: chsh -s $zsh_path"
  fi
}

ensure_linux_basics
ensure_bun_linux
symlink_dotfiles
install_oh_my_zsh
run_macos_bundle_and_defaults
link_zshrc
ensure_user_zdotdir_for_ide_terminals
install_zsh_plugin_repos
chmod_home_bin
set_zsh_as_login_shell
note_vscode_reference

echo "🎉 Installation complete!"
if [[ -x "${HOME}/.bun/bin/bun" ]] && ! command -v bun >/dev/null 2>&1; then
  echo "💡 bun is installed but not on PATH in this shell yet — run: source ~/.zshrc"
fi
if is_linux && has_apt && [[ "${INSTALL_LINUX_EXTRAS:-1}" == "0" ]]; then
  echo "💡 Skipped bat, fd-find, fzf, jq (INSTALL_LINUX_EXTRAS=0). Unset or set to 1 to install them next run."
fi
if ! is_linux; then
  echo "💡 VS Code/Cursor (zsh): if the integrated terminal skips your aliases, set USER_ZDOTDIR to your home directory in terminal.integrated.env.osx (or disable shell integration to test)."
fi
