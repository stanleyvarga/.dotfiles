# Linux — dotfiles behavior

What this checkout configures on **Ubuntu/Debian Linux** after `./install.sh` (or the equivalent symlinks). Shared Zsh/Git behavior is the same on macOS unless noted below.

## Install and layout

- Repo can live anywhere; `install.sh` sets `DOTFILES` from its path.
- **App configs** live under [`config/<app>/`](../config/) and are symlinked by `install.sh` (mostly into `~/.config/`; Konsole uses KDE’s data path).
  - Git → `~/.config/git/config` and `~/.config/git/ignore` (also `~/.gitignore`)
  - mise → `~/.config/mise/config.toml`
  - Starship → `~/.config/starship.toml`
  - Warp → `~/.config/warp-terminal/keybindings.yaml`
  - Konsole → `~/.local/share/kxmlgui5/konsole/sessionui.rc`
- **Linux install hooks** stay in [`linux/`](../linux/) (`set-terminal-defaults`, `set-keyboard-defaults`) — scripts, not app dotfiles.
- Zsh stays in [`zsh/`](../zsh/) and links to `~/.zshenv`, `~/.zprofile`, `~/.zshrc`.
- Custom commands in [`bin/bin/`](../bin/bin/) → `~/bin`.

Re-link without apt/shell changes:

```bash
SKIP_BREW_BUNDLE=1 SKIP_CHSH=1 ./install.sh
```

## Git

**Tracked config:** [`config/git/config`](../config/git/config)  
**Identity (not in repo):** `~/.gitconfig.local` — name and email; included last so it overrides the tracked file.

**Defaults worth knowing**

| Setting | Behavior |
| --- | --- |
| `init.defaultBranch` | `main` for new repos |
| `rebase.autoSquash` | `fixup!` / `squash!` commits auto-squash in interactive rebase |
| `diff.renames` | `copies` — better rename/copy detection |
| `log.date` | `human` |
| `help.autoCorrect` | `prompt` — suggests a fix for typos; does **not** run commands without your OK |
| `pull.rebase` | `false` (merge pulls, not rebase) |

**Global ignore** ([`config/git/ignore`](../config/git/ignore)): `.DS_Store`, `Thumbs.db`, `*~`, `*.swp`, `npm-debug.log` — hidden in every repo.

**Safe Git helpers** (in `~/bin`, invoked as `git undo`, etc.):

| Command | What it does |
| --- | --- |
| `git undo` | `reset --soft HEAD~1` (changes stay staged) |
| `git pf` | `push --force-with-lease` |
| `git amend` | `commit --amend --no-edit` |
| `git forget` | Deletes local branches whose upstream is **gone** (never `main`, `master`, or current branch) |

Rules for all four:

- `-n` / `--dry-run` — print plan only
- Otherwise: `Proceed? [y/N]`; only `y` or `yes` runs the action
- No TTY → exit without changes
- No `--yes` / `-y` / `-f`

## Shell (Zsh)

See [README — Daily workflow](../README.md#daily-workflow--shortcuts). Additional aliases:

| Alias / function | Action |
| --- | --- |
| `~`, `home` | `cd ~` |
| `..`, `...`, `....` | Up 1–3 directories |
| `-` | `cd -` |
| `path` | Print `$PATH` one entry per line |
| `myip` | Public IP via OpenDNS |
| `sudo` | `sudo ` (trailing space so aliases work after `sudo`) |
| `extract <archive>` | Unpack `.tar.gz`, `.zip`, `.7z`, etc. (archive kept on disk) |

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

Linux install uses **apt** for CLI tools listed in `install.sh` (not the macOS Brewfile). `gh` and `shellcheck` are Brewfile-only unless you install them yourself on Linux.

## Config paths quick reference

| App | Source in repo | Symlink target |
| --- | --- | --- |
| Git | `config/git/config`, `config/git/ignore` | `~/.config/git/*`, `~/.gitignore` |
| mise | `config/mise/config.toml` | `~/.config/mise/config.toml` |
| Starship | `config/starship.toml` | `~/.config/starship.toml` |
| Warp | `config/warp-terminal/keybindings.yaml` | `~/.config/warp-terminal/keybindings.yaml` |
| Konsole | `config/konsole/sessionui.rc` | `~/.local/share/kxmlgui5/konsole/sessionui.rc` |