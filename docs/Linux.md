# Linux — dotfiles behavior

What this checkout configures on **Ubuntu/Debian Linux** after `./install.sh` (or the equivalent symlinks). Shared Git, aliases, and `~/bin` commands: [Commands.md](./Commands.md).

## Install and layout

- Repo can live anywhere; `install.sh` sets `DOTFILES` from its path.
- **App configs** live under [`config/<app>/`](../config/) and are symlinked by `install.sh` (mostly into `~/.config/`; Konsole uses KDE’s data path).
  - Git → `~/.config/git/config` and `~/.config/git/ignore` (also `~/.gitignore`)
  - mise → `~/.config/mise/config.toml`
  - Starship → `~/.config/starship.toml`
  - bat → `~/.config/bat/config`
  - Warp → `~/.config/warp-terminal/keybindings.yaml`
  - Konsole → `~/.local/share/kxmlgui5/konsole/sessionui.rc`
- **Linux install hooks** stay in [`linux/`](../linux/) (`set-terminal-defaults`, `set-keyboard-defaults`) — scripts, not app dotfiles.
- Zsh stays in [`zsh/`](../zsh/) and links to `~/.zshenv`, `~/.zprofile`, `~/.zshrc`.
- Custom commands in [`bin/bin/`](../bin/bin/) → `~/bin`.

Re-link without apt/shell changes:

```bash
SKIP_BREW_BUNDLE=1 SKIP_CHSH=1 ./install.sh
```

## Keyboard — Caps Lock → Control

Applied by [`linux/set-keyboard-defaults`](../linux/set-keyboard-defaults) when you run `install.sh` (or run the script yourself).

- **GNOME:** `caps:ctrl_modifier` in `org.gnome.desktop.input-sources` `xkb-options` (immediate).
- **KDE:** `Options=caps:ctrl_modifier` in `~/.config/kxkbrc` (often needs re-login).
- **Neither desktop:** script skips with a message.

**Revert (GNOME):**

```bash
gsettings set org.gnome.desktop.input-sources xkb-options "[]"
# or remove only caps:ctrl_modifier from the existing array
```

In **Warp**, **Konsole**, and **GNOME Terminal**, copy/paste is **Ctrl+C / Ctrl+V** (see [`linux/set-terminal-defaults`](../linux/set-terminal-defaults)). After Caps Lock remap, **Caps Lock+C** copies; use **Ctrl+Shift+C** or the terminal’s interrupt binding to cancel a running command where applicable.

## Terminals

- **Konsole:** [`config/konsole/sessionui.rc`](../config/konsole/sessionui.rc) linked into KDE data dir.
- **GNOME Terminal:** gsettings copy/paste overrides.
- **Warp:** [`config/warp-terminal/keybindings.yaml`](../config/warp-terminal/keybindings.yaml) — restart Warp after changes.

## Packages

Linux install uses **apt** for CLI tools listed in `install.sh` (not the macOS Brewfile). `gh` and `shellcheck` are Brewfile-only unless you install them yourself on Linux. `zsbrew` is macOS-only; on Linux it exits immediately.

## Config paths quick reference

| App | Source in repo | Symlink target |
| --- | --- | --- |
| Git | `config/git/config`, `config/git/ignore` | `~/.config/git/*`, `~/.gitignore` |
| mise | `config/mise/config.toml` | `~/.config/mise/config.toml` |
| Starship | `config/starship.toml` | `~/.config/starship.toml` |
| bat | `config/bat/config` | `~/.config/bat/config` |
| Warp | `config/warp-terminal/keybindings.yaml` | `~/.config/warp-terminal/keybindings.yaml` |
| Konsole | `config/konsole/sessionui.rc` | `~/.local/share/kxmlgui5/konsole/sessionui.rc` |