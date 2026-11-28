#!/usr/bin/env bash
# Clone anywhere, run ./install.sh — cross-platform (macOS + Ubuntu/Debian), no GNU stow.
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
  echo "🔗 Linking bin, config/git, config/mise, config/starship, root"
  link_dir_contents "$DOTFILES/bin/bin" "$HOME/bin"
  mkdir -p "$HOME/.config/git" "$HOME/.config/mise"
  link_file "$DOTFILES/config/git/config" "$HOME/.config/git/config"
  link_file "$DOTFILES/config/git/ignore" "$HOME/.config/git/ignore"
  link_file "$DOTFILES/config/git/ignore" "$HOME/.gitignore"
  link_file "$DOTFILES/root/.sleep" "$HOME/.sleep"
  link_file "$DOTFILES/root/.wakeup" "$HOME/.wakeup"
  link_file "$DOTFILES/config/mise/config.toml" "$HOME/.config/mise/config.toml"
  link_file "$DOTFILES/config/starship.toml" "$HOME/.config/starship.toml"
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
  echo "🔧 Installing Linux prerequisites (git, curl, zsh, unzip, bat)"
  sudo apt-get update
  local base_pkgs=(git curl zsh unzip bat)
  if apt-cache show eza >/dev/null 2>&1; then
    base_pkgs+=(eza)
  fi
  sudo apt-get install -y "${base_pkgs[@]}"

  if [[ "${INSTALL_LINUX_EXTRAS:-1}" != "0" ]]; then
    local extra_pkgs=(fd-find fzf jq ripgrep)
    if apt-cache show git-delta >/dev/null 2>&1; then
      extra_pkgs+=(git-delta)
    fi
    echo "🔧 Installing Linux CLI tools (${extra_pkgs[*]})"
    sudo apt-get install -y "${extra_pkgs[@]}"
  fi
}

ensure_linux_cli_shims() {
  if ! is_linux; then
    return 0
  fi
  mkdir -p "$HOME/.local/bin"
  # Debian/Ubuntu ship bat as batcat and fd as fdfind; configs expect `bat` and `fd` on PATH.
  if command -v batcat >/dev/null 2>&1; then
    ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
    echo "✅ ~/.local/bin/bat → batcat (Debian package name)"
  elif ! command -v bat >/dev/null 2>&1; then
    echo "⚠️  bat not found — on Debian/Ubuntu run: sudo apt-get install -y bat"
  fi
  if command -v fdfind >/dev/null 2>&1; then
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    echo "✅ ~/.local/bin/fd → fdfind (Debian package name)"
  fi
}

ensure_mise_linux() {
  if ! is_linux; then
    return 0
  fi
  if command -v mise >/dev/null 2>&1 || [[ -x "$HOME/.local/bin/mise" ]]; then
    echo "✅ mise is already installed"
    return 0
  fi
  if ! command -v curl >/dev/null 2>&1; then
    echo "⚠️  curl not found; install curl then re-run install.sh for mise"
    return 0
  fi
  echo "🔧 Installing mise (https://mise.jdx.dev)"
  curl -fsSL https://mise.run | sh
}

ensure_starship_linux() {
  if ! is_linux; then
    return 0
  fi
  if command -v starship >/dev/null 2>&1 || [[ -x "$HOME/.local/bin/starship" ]]; then
    echo "✅ starship is already installed"
    return 0
  fi
  if ! command -v curl >/dev/null 2>&1; then
    echo "⚠️  curl not found; install curl then re-run install.sh for starship"
    return 0
  fi
  mkdir -p "$HOME/.local/bin"
  echo "🔧 Installing starship (https://starship.rs)"
  curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
}

ensure_zoxide_linux() {
  if ! is_linux; then
    return 0
  fi
  if [[ "${INSTALL_LINUX_EXTRAS:-1}" == "0" ]]; then
    return 0
  fi
  if command -v zoxide >/dev/null 2>&1 || [[ -x "$HOME/.local/bin/zoxide" ]]; then
    echo "✅ zoxide is already installed"
    return 0
  fi
  if ! command -v curl >/dev/null 2>&1; then
    echo "⚠️  curl not found; install curl then re-run install.sh for zoxide"
    return 0
  fi
  echo "🔧 Installing zoxide (https://github.com/ajeetdsouza/zoxide)"
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
}

ensure_bun_linux() {
  if ! is_linux; then
    return 0
  fi
  if command -v bun >/dev/null 2>&1 || [[ -x "$HOME/.bun/bin/bun" ]]; then
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
  curl -fsSL https://bun.sh/install | SHELL="${SHELL:-/bin/zsh}" bash
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

install_antidote() {
  if [[ -d "$HOME/.antidote" ]]; then
    echo "✅ Antidote is already installed"
    return 0
  fi
  echo "🔧 Installing Antidote (~/.antidote)"
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
}

run_linux_terminal_defaults() {
  if ! is_linux; then
    return 0
  fi
  echo "🔧 Setting Linux terminal defaults (Ctrl+C / Ctrl+V copy-paste)"
  chmod +x "$DOTFILES/linux/set-terminal-defaults"
  "$DOTFILES/linux/set-terminal-defaults"
}

run_linux_keyboard_defaults() {
  if ! is_linux; then
    return 0
  fi
  echo "🔧 Setting Linux keyboard defaults (Caps Lock → Control)"
  chmod +x "$DOTFILES/linux/set-keyboard-defaults"
  "$DOTFILES/linux/set-keyboard-defaults"
}

run_macos_bundle_and_defaults() {
  if ! is_macos; then
    echo "💽 Not running on macOS — skipping Homebrew bundle and defaults"
    return 0
  fi
  ensure_homebrew
  if [[ "${SKIP_BREW_BUNDLE:-}" == "1" ]]; then
    echo "⏭️  SKIP_BREW_BUNDLE=1 — skipping brew bundle"
  elif brew bundle check --file="$DOTFILES/homebrew/Brewfile" >/dev/null 2>&1; then
    echo "✅ Brewfile already satisfied — skip brew bundle (use zsbrew to sync/upgrade)"
  else
    echo "🔧 Brewfile has missing packages — running brew bundle"
    brew bundle install --no-upgrade --file="$DOTFILES/homebrew/Brewfile"
  fi
  echo "🔧 Setting macOS defaults"
  chmod +x "$DOTFILES/macos/set-defaults"
  (cd "$DOTFILES/macos" && ./set-defaults)
}

ensure_mise_tools() {
  local mise_bin=""
  if command -v mise >/dev/null 2>&1; then
    mise_bin=$(command -v mise)
  elif [[ -x "$HOME/.local/bin/mise" ]]; then
    mise_bin="$HOME/.local/bin/mise"
  fi
  if [[ -z "$mise_bin" ]]; then
    echo "⚠️  mise not found — skipping runtime install"
    return 0
  fi
  echo "🔧 Syncing mise global tools (from config/mise/config.toml)"
  "$mise_bin" install --yes || echo "⚠️  mise install encountered an issue; run 'mise install' manually"
}

link_zsh_files() {
  echo "🔗 Linking ~/.zshenv, ~/.zprofile, ~/.zshrc"
  link_file "$DOTFILES/zsh/.zshenv" "$HOME/.zshenv"
  link_file "$DOTFILES/zsh/.zprofile" "$HOME/.zprofile"
  link_file "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
  # Remove stale compiled file in $HOME so zsh always reads the symlinked .zshrc
  rm -f "$HOME/.zshrc.zwc"
}

build_zsh_caches() {
  if ! command -v zsh >/dev/null 2>&1; then
    return 0
  fi
  echo "⚡ Building Antidote static plugin bundle & compiling zsh configs (.zwc)"
  zsh -f -c '
    export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
    cache_dir="$XDG_CACHE_HOME/zsh"
    mkdir -p "$cache_dir"
    if [[ -r "$HOME/.antidote/antidote.zsh" && -r "$DOTFILES/zsh/zsh_plugins.txt" ]]; then
      source "$HOME/.antidote/antidote.zsh"
      antidote bundle <"$DOTFILES/zsh/zsh_plugins.txt" >|"$cache_dir/zsh_plugins.zsh"
      zcompile -U "$cache_dir/zsh_plugins.zsh" 2>/dev/null || true
    fi
    for f in \
      "$DOTFILES/zsh/.zshenv" \
      "$DOTFILES/zsh/.zprofile" \
      "$DOTFILES/zsh/.zshrc" \
      "$DOTFILES/zsh/zsh.init" \
      "$DOTFILES/zsh/config/options" \
      "$DOTFILES/zsh/config/paths" \
      "$DOTFILES/zsh/config/aliases" \
      "$DOTFILES/zsh/config/eval" \
      "$DOTFILES/zsh/config/functions"
    do
      [[ -r $f ]] || continue
      zcompile -U "$f" 2>/dev/null || true
    done
  ' || true
}

ensure_ricksay() {
  if command -v ricksay >/dev/null 2>&1; then
    echo "✅ ricksay is already installed"
    return 0
  fi
  local pip=""
  if [[ -x /opt/homebrew/opt/python@3.11/bin/pip3 ]]; then
    pip=/opt/homebrew/opt/python@3.11/bin/pip3
  elif command -v pip3 >/dev/null 2>&1; then
    pip=$(command -v pip3)
  fi
  if [[ -z "$pip" ]]; then
    echo "⚠️  pip3 not found — skip ricksay"
    return 0
  fi
  echo "🔧 Installing ricksay (pip)"
  "$pip" install --user ricksay || "$pip" install ricksay || echo "⚠️  ricksay install failed"
}

# Cursor/VS Code zsh shell integration sources $USER_ZDOTDIR/.zshrc on Linux.
ensure_user_zdotdir_for_ide_terminals() {
  if is_linux; then
    mkdir -p "$HOME/.config/environment.d"
    printf 'USER_ZDOTDIR=%s\n' "$HOME" >"$HOME/.config/environment.d/99-dotfiles-user-zdotdir.conf"
    echo "📝 Wrote ~/.config/environment.d/99-dotfiles-user-zdotdir.conf (USER_ZDOTDIR=$HOME)"
    echo "   Restart Cursor/your session so integrated terminals inherit USER_ZDOTDIR."
  fi
}

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
ensure_linux_cli_shims
ensure_mise_linux
ensure_starship_linux
ensure_zoxide_linux
ensure_bun_linux
symlink_dotfiles
install_antidote
run_macos_bundle_and_defaults
run_linux_terminal_defaults
run_linux_keyboard_defaults
ensure_mise_tools
link_zsh_files
ensure_user_zdotdir_for_ide_terminals
ensure_ricksay
build_zsh_caches
chmod_home_bin
set_zsh_as_login_shell
note_vscode_reference

echo "🎉 Installation complete!"
if is_linux && has_apt && [[ "${INSTALL_LINUX_EXTRAS:-1}" == "0" ]]; then
  echo "💡 Skipped fd-find, fzf, jq, ripgrep, git-delta, zoxide (INSTALL_LINUX_EXTRAS=0)."
fi
if ! is_linux; then
  echo "💡 VS Code/Cursor (zsh): if the integrated terminal skips your aliases, set USER_ZDOTDIR to your home directory in terminal.integrated.env.osx."
fi
