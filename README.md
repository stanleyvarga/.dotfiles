
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

## Install

Clone this repo to any path (for example `git clone <repo-url> ~/.dotfiles`), then from that directory:

```bash
chmod +x install.sh   # first clone only, if needed
./install.sh
```

The script sets `DOTFILES` from its own location, symlinks `bin`, `git`, `root`, and `~/.zshrc` → `zsh/.zshrc` into your home directory (no GNU stow), installs Oh My Zsh if missing, then on **macOS** installs Homebrew if missing and runs `brew bundle` **only when the Brewfile has missing packages** (use `zsbrew` to sync/upgrade), and on **Debian/Ubuntu** runs `apt` to install `git`, `curl`, `zsh`, `eza`, and by default `bat`, `fd-find`, `fzf`, and `jq`. At the end it sets **zsh as your login shell** with `chsh` (you may be prompted for your account password). If your zsh binary is not listed in `/etc/shells` (common for Homebrew’s zsh on macOS), the script adds it with `sudo` first.

**Optional environment variables**

- `SKIP_BREW_BUNDLE=1` — macOS only; skip `brew bundle` for a faster run when you only want symlinks, Oh My Zsh, and plugin clones.
- `SKIP_CHSH=1` — do not change the login shell (skip `chsh` and `/etc/shells` updates).
- `INSTALL_LINUX_EXTRAS=0` — Debian/Ubuntu only; skip installing `bat`, `fd-find`, `fzf`, and `jq` (they are installed by default otherwise).

**After install**

- After you **pull** shell/config changes, open a new terminal (or `rzsh`) — `~/.zshrc` is a symlink into the repo, so pulls apply without re-running install. Re-run `./install.sh` when you need new brew packages, plugin clones, or bin/git/root re-links.
- Open a **new** terminal (or log out and back in) so the login shell change applies.
- On macOS, Xcode Command Line Tools are often required before Homebrew; if the Homebrew installer fails, install CLT first (`xcode-select --install`).

### Custom binaries

Scripts under `bin/bin/` are symlinked into `~/bin`. See [bin/bin/Readme.md](./bin/bin/Readme.md) for the available commands (`dotfiles`, `zsbrew`, `ytdl`, `ytdl-all`, etc.).

### VS Code / Cursor

`vscode/settings.json` and `vscode/keybindings.json` are a **reference snapshot** — install does **not** overwrite live IDE settings (your Cursor/Code User files are usually newer). To apply manually:

```bash
# Cursor (macOS)
cp "$DOTFILES/vscode/settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"
cp "$DOTFILES/vscode/keybindings.json" "$HOME/Library/Application Support/Cursor/User/keybindings.json"

# VS Code (macOS)
cp "$DOTFILES/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
cp "$DOTFILES/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
```

Prefer diffing against your live files before copying.

- Startup takes around 0.1 - 0.2 seconds 🎉
- I use shitload of plugins & aliases
- Oh my zsh 😱

## Interesting resources
- 🔗 [The Art Of Command Line](https://github.com/jlevy/the-art-of-command-line)
- 🔗 [Command Line Interface Guidelines](https://clig.dev/#foreword)

## People to follow
- 🔗 [Robby Russell](https://github.com/robbyrussell)

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
