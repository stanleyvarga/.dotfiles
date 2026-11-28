## `.dotfiles`

Ballad of `Dotfiles`

>In a land where *nix reigns supreme,  
>A tale unfolds, a geek's daydream,  
>Of .dotfiles vast and secrets deep,  
>Where coders toil while others sleep.  
>
>The .vimrc, a sacred scroll,  
>With mappings, macros, and control,  
>They tweak and twiddle, line by line,  
>To craft a setup so divine.  
>
>Yet IDEs, with ease and grace,  
>Lie just a click from their embrace,  
>But nay, the .dotfile's siren call,  
>Draws them back, enthralls them all. 
>
>A zsh prompt, so sleek, so neat,  
>They script it 'til it's obsolete,  
>Weeks have passed, in screen’s soft light,  
>In search of settings just so right.  
>
>For hours lost in config bliss,  
>They chase a dream they can't dismiss,  
>Of systems perfect, finely tuned,  
>Yet practical? Perhaps lampooned.  
>
>So here's a toast to .dotfile lore,  
>To hours spent, and configs more,  
>In endless loops they tweak and twine,  
>Their systems perfect, by design.  
>
>But as the sun sets, and moonlight beams,  
>They wake up from the config dreams,  
>And wonder, with a wistful sigh,  
>Was all that tweaking worth the while?  

![Unicorns](./unicorn.webp)

## Architecture

Cross-platform (**macOS** + **Ubuntu/Debian Linux**) ultra-fast Zsh setup:

- **Pure Zsh + [Antidote](https://antidote.sh/)** static compiled plugin bundle (no Oh My Zsh overhead)
- **[Starship](https://starship.rs/)** minimal single-line prompt (`config/starship.toml`)
- **[mise](https://mise.jdx.dev/)** unified runtime manager for Node, Ruby, Python (reads `.nvmrc`, `.node-version`, `.ruby-version`, `.python-version`; shims in `~/.zshenv` so IDEs, scripts, and agents always resolve Node immediately without lazy-loading hacks)
- **Cached tool inits** (`~/.cache/zsh/*.zsh.zwc`): `starship`, `mise`, `zoxide`, `wt`, `fzf` (`fd` + `bat` preview), and deferred `atuin` (`Ctrl+R`)
- **Modern Git defaults** (`config/git/config`): `delta` diff pager (with automatic `less` fallback if `delta` is missing), `histogram` diff, `zdiff3` conflicts, `rerere`, and `fsmonitor`
- **Startup time:** ~40–60 ms steady-state (`bench-zsh` to measure)

## Platform docs

- [docs/Commands.md](./docs/Commands.md) — Git helpers, aliases, and `~/bin` (macOS and Linux)
- [docs/Linux.md](./docs/Linux.md) — Ubuntu/Debian install, keyboard, terminals
- [docs/Macos.md](./docs/Macos.md) — Homebrew, defaults, wallpapers, sleep/wake
- [docs/Apps.md](./docs/Apps.md) — other projects (not installed by this repo)

## Install

Clone this repo to any path (for example `git clone <repo-url> ~/.dotfiles`), then from that directory:

```bash
chmod +x install.sh   # first clone only, if needed
./install.sh
```

The script sets `DOTFILES` from its own location, symlinks `bin`, `git`, `root`, `mise`, `starship`, and `~/.zshenv` / `~/.zprofile` / `~/.zshrc` into your home directory (no GNU stow), installs **Antidote** (`~/.antidote`), and pre-builds the static plugin bundle and `.zwc` caches.

- **macOS:** installs Homebrew if missing, runs `brew bundle` only when `homebrew/Brewfile` has missing packages (use `zsbrew` to sync/upgrade), syncs `mise` tools, and applies `macos/set-defaults`.
- **Ubuntu/Debian:** installs `git`, `curl`, `zsh`, `unzip`, `bat` (and `eza`, `fd-find`, `fzf`, `jq`, `ripgrep`, `git-delta` when available in `apt`), links `~/.local/bin/bat` → `batcat` and `~/.local/bin/fd` → `fdfind`, installs `mise`, `starship`, `zoxide`, and `bun` into `~/.local/bin` / `~/.bun/bin`, and applies `linux/set-terminal-defaults` (**Konsole**, **GNOME Terminal**, and **Warp**: **Ctrl+C / Ctrl+V** for copy-paste; **Ctrl+Shift+C** for interrupt/cancel). **Quit and reopen Warp** after install so `keybindings.yaml` loads.

At the end it sets **zsh as your login shell** with `chsh` (adding zsh to `/etc/shells` via `sudo` if needed).

**Optional environment variables**

- `SKIP_BREW_BUNDLE=1` — macOS only; skip `brew bundle` for a faster re-link run.
- `SKIP_CHSH=1` — do not change the login shell.
- `INSTALL_LINUX_EXTRAS=0` — Debian/Ubuntu only; skip installing `fd-find`, `fzf`, `jq`, `ripgrep`, `git-delta`, and `zoxide`.

**After install**

- After pulling config changes, open a new terminal (or run `rzsh`). Re-run `./install.sh` when adding Brewfile packages or new scripts.
- Run `bench-zsh` anytime to benchmark interactive shell startup speed.
- On macOS, Xcode Command Line Tools are required before Homebrew (`xcode-select --install`).

## Daily Workflow & Shortcuts

### Keyboard shortcuts

| Shortcut | Tool | What it does |
| --- | --- | --- |
| `Ctrl+T` | `fzf` + `fd` + `bat` | Fuzzy-find any file under the current directory with a live syntax-highlighted preview and insert its path at your cursor (e.g. type `code `, press `Ctrl+T`, pick a file). |
| `Ctrl+G` | `fzf` + `fd` + `eza` | **"Go"** — fuzzy-find any subdirectory under your current folder with a live directory tree preview and `cd` straight into it (works on macOS & Ubuntu without Option/Meta tweaks). |
| `Ctrl+R` | `atuin` | Full-screen interactive search across your entire shell history (filterable by directory, session, or global). Falls back to `fzf` history search if `atuin` isn't installed. |
| `→` (Right Arrow) | `zsh-autosuggestions` | Accept the grey inline command suggestion based on your history. |
| `↑` / `↓` | `atuin` / Zsh | Search previous commands matching what you've already typed. |
| `Tab` / `Shift+Tab` | Zsh completion | Interactive case-insensitive completion menu (arrow keys to pick). |
| `Ctrl+←` / `Ctrl+→` *(or `Option+←/→`)* | Zsh | Jump backward / forward by word. |

### Smart directory jumping with `z` (Zoxide)

`zoxide` watches every `cd` you run and builds a **frecency** (frequency + recency) index of your folders — no setup needed.

```bash
z dot              # jumps to ~/.dotfiles (partial match, from anywhere)
z doc dev          # matches multiple fragments in order (e.g. ~/Documents/dev)
zi                 # opens an interactive fzf picker of your most-used folders
zi app             # interactive picker filtered by "app"
z -                # jump back to your previous directory
```

You also have the built-in directory stack for recent folders in the current tab:

```bash
d                  # list the last 10 visited directories (numbered 0–9)
1                  # jump back 1 directory (`2`, `3`, ... up to `9`)
mkcd new-project   # mkdir -p + cd into it in one step
```

### Clipboard helpers (`copypath`, `copyfile`, `copyssh`)

Works out of the box on both **macOS** (`pbcopy`) and **Ubuntu/Linux** (`wl-copy`, `xclip`, `xsel`):

```bash
copypath                  # copy the full absolute path of the current directory
copypath src/index.ts     # copy the full absolute path of a specific file or folder
copyfile package.json     # copy the entire contents of a file to your clipboard
copyssh                   # copy ~/.ssh/id_rsa.pub to your clipboard
```

### History search (`atuin`)

- **`Ctrl+R`** — interactive history search (press `Ctrl+R` again inside Atuin to toggle filter modes: global / host / session / directory)
- **`h`** — open interactive Atuin search (`atuin search -i`)
- **`hf`** — search only **failed** commands (`atuin search --exclude-exit 0 -i`), great for debugging

### Node & runtime management (`mise`)

`mise` replaces `nvm`, `rbenv`, and `pyenv`. Shims live in `~/.zshenv`, so `node`, `npm`, `npx`, global CLIs, scripts, Cursor, and AI agents **always work immediately** without running `node -v` first.

```bash
mise ls                      # list installed & active tool versions
mise use --global node@22    # change default global Node version
mise use node@20             # pin a project's Node version in mise.toml
mise install node@24         # install an additional version
```

Entering any repo with `.nvmrc`, `.node-version`, `.ruby-version`, or `.python-version` switches versions automatically on `cd`.

### Files, Git & quick config helpers

- **Better `ls` (`eza`):** `l` (detailed list with icons), `la` / `ll` (all files + metadata), `lt` (2-level tree), `ld` (directories only), `lM` / `lS` (sort by modified / size)
- **Better `cat` & search:** `cat` uses `bat` with syntax highlighting; `rg <pattern>` (`ripgrep`) for instant codebase grep; `fd <name>` for fast file search
- **Git + `delta`:** `git diff` and `git log -p` automatically render side-by-side/highlighted diffs via `delta` (falling back to `less` if `delta` isn't installed); full OMZ git aliases (`gst`, `gaa`, `gco`, `gp`, `gl`, `gd`, etc.) plus `gcm "msg"` and `gcmp "msg"` (commit + push)
- **Cheatsheets & benchmarks:** `cht js/map+object` (quick terminal cheatsheet from cht.sh), `bench-zsh` (measure shell startup speed)
- **Dotfiles shortcuts:** `e:zshrc`, `e:alias`, `e:path`, `e:plugins`, `e:starship`, and `rzsh` (reload `~/.zshrc`)

### Custom binaries

Scripts under `bin/bin/` are symlinked into `~/bin`. See [docs/Commands.md](./docs/Commands.md) and [bin/bin/Readme.md](./bin/bin/Readme.md) (`dotfiles`, `zsbrew`, `ytdl`, `ytdl-all`, git helpers, etc.).

### VS Code / Cursor

`vscode/settings.json` and `vscode/keybindings.json` are a **reference snapshot** — install does **not** overwrite live IDE settings. To apply manually:

```bash
# Cursor (macOS)
cp "$DOTFILES/vscode/settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"
cp "$DOTFILES/vscode/keybindings.json" "$HOME/Library/Application Support/Cursor/User/keybindings.json"

# VS Code (macOS)
cp "$DOTFILES/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
cp "$DOTFILES/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
```

Prefer diffing against your live files before copying.

## Interesting resources
- 🔗 [The Art Of Command Line](https://github.com/jlevy/the-art-of-command-line)
- 🔗 [Command Line Interface Guidelines](https://clig.dev/#foreword)

## Command-line tools
- 📦 [Btop](https://github.com/aristocratos/btop)
- 📦 [Hyperfine](https://github.com/sharkdp/hyperfine)
- 📦 [duf](https://github.com/muesli/duf)
- 📦 [scc](https://github.com/boyter/scc)
- 📦 [just](https://github.com/casey/just)
- 📦 [asciinema](https://asciinema.org/)
- 📦 [mapscii](https://github.com/rastapasta/mapscii)

## Other resources
- 🔗 ASCII fonts generator [ASCII Fonts](https://patorjk.com/software/taag/#p=display&h=2&f=Banner3-D&t=text%0A)
- 🔤 Programming fonts [programmingfonts.org](https://www.programmingfonts.org/#monaspace-neon)
- 🚀 Static web publishing [Surge](https://surge.sh/)
