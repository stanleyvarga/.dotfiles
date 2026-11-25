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
- **[Starship](https://starship.rs/)** minimal single-line prompt (`starship/starship.toml`)
- **[mise](https://mise.jdx.dev/)** unified runtime manager for Node, Ruby, Python (reads `.nvmrc`, `.node-version`, `.ruby-version`, `.python-version`; shims in `~/.zshenv` so IDEs, scripts, and agents always resolve Node immediately without lazy-loading hacks)
- **Cached tool inits** (`~/.cache/zsh/*.zsh.zwc`): `starship`, `mise`, `zoxide`, `wt`, `fzf` (`fd` + `bat` preview), and deferred `atuin` (`Ctrl+R`)
- **Modern Git defaults** (`git/.gitconfig`): `delta` diff pager (with automatic `less` fallback if `delta` is missing), `histogram` diff, `zdiff3` conflicts, `rerere`, and `fsmonitor`
- **Startup time:** ~40–60 ms steady-state (`bench-zsh` to measure)

## Install

Clone this repo to any path (for example `git clone <repo-url> ~/.dotfiles`), then from that directory:

```bash
chmod +x install.sh   # first clone only, if needed
./install.sh
```

The script sets `DOTFILES` from its own location, symlinks `bin`, `git`, `root`, `mise`, `starship`, and `~/.zshenv` / `~/.zprofile` / `~/.zshrc` into your home directory (no GNU stow), installs **Antidote** (`~/.antidote`), and pre-builds the static plugin bundle and `.zwc` caches.

- **macOS:** installs Homebrew if missing, runs `brew bundle` only when `homebrew/Brewfile` has missing packages (use `zsbrew` to sync/upgrade), syncs `mise` tools, and applies `macos/set-defaults`.
- **Ubuntu/Debian:** installs `git`, `curl`, `zsh`, `unzip`, `bat` (and `eza`, `fd-find`, `fzf`, `jq`, `ripgrep`, `git-delta` when available in `apt`), links `~/.local/bin/bat` → `batcat` and `~/.local/bin/fd` → `fdfind`, and installs `mise`, `starship`, `zoxide`, and `bun` into `~/.local/bin` / `~/.bun/bin`.

At the end it sets **zsh as your login shell** with `chsh` (adding zsh to `/etc/shells` via `sudo` if needed).

**Optional environment variables**

- `SKIP_BREW_BUNDLE=1` — macOS only; skip `brew bundle` for a faster re-link run.
- `SKIP_CHSH=1` — do not change the login shell.
- `INSTALL_LINUX_EXTRAS=0` — Debian/Ubuntu only; skip installing `fd-find`, `fzf`, `jq`, `ripgrep`, `git-delta`, and `zoxide`.

**After install**

- After pulling config changes, open a new terminal (or run `rzsh`). Re-run `./install.sh` when adding Brewfile packages or new scripts.
- Run `bench-zsh` anytime to benchmark interactive shell startup speed.
- On macOS, Xcode Command Line Tools are required before Homebrew (`xcode-select --install`).

### Custom binaries

Scripts under `bin/bin/` are symlinked into `~/bin`. See [bin/bin/Readme.md](./bin/bin/Readme.md) for the available commands (`dotfiles`, `zsbrew`, `ytdl`, `ytdl-all`, etc.).

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
