# Commands and shell

Cross-platform behavior after `./install.sh` on **macOS** and **Ubuntu/Debian Linux**. Install paths, keyboard, and terminals are in [Linux.md](./Linux.md) and [Macos.md](./Macos.md).

Interactive shortcuts (fzf, zoxide, atuin, mise): [README — Daily workflow](../README.md#daily-workflow--shortcuts). Source for aliases and functions: [`zsh/config/aliases`](../zsh/config/aliases), [`zsh/config/functions`](../zsh/config/functions). Scripts in [`bin/bin/`](../bin/bin/) → `~/bin` ([`bin/bin/Readme.md`](../bin/bin/Readme.md)).

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

`git diff` / `git log -p` use **delta** when installed (otherwise `less`). OMZ-style git aliases (`gst`, `gaa`, `gco`, `gp`, …) apply on both platforms. Helpers: `gcm "msg"` (commit), `gcmp "msg"` (commit + push).

### Safe Git helpers

Invoked as `git undo`, etc. Scripts: [`bin/bin/git-*`](../bin/bin/).

Rules for all four:

- `-n` / `--dry-run` — print the plan and exit without changing anything
- Otherwise: `Proceed? [y/N]`; only `y` or `yes` runs the action
- No TTY → exit without changes
- `-y` / `--yes` / `-f` / `--force` are refused (no non-interactive bypass)

#### `git undo`

Removes the latest commit with `git reset --soft HEAD~1`. The commit’s changes stay **staged** so you can edit and commit again.

```bash
git undo           # interactive
git undo -n        # show plan only
```

Shows `git log -1 --oneline` for the commit that would be undone. Exits with an error if there is no parent commit (e.g. first commit on the branch).

#### `git amend`

Amends the latest commit with `git commit --amend --no-edit` (message unchanged). Stage what you want to fold in first:

```bash
git add path/to/file
git amend
git amend -n       # dry run
```

Shows the latest commit before asking. Exits if the repo has no commits yet.

#### `git pf`

Force-pushes the **current branch** with `git push --force-with-lease` (safer than `--force`). Prints `git status -sb` before the prompt. Extra arguments are passed through to `git push`.

```bash
git pf
git pf -n          # runs git push --force-with-lease --dry-run
```

Exits on detached HEAD — check out a branch first. The script’s plan line mentions `origin` and the branch name; the actual push follows Git’s default upstream unless you pass more args.

#### `git forget`

Deletes **local** branches whose upstream is **gone** (`git branch -vv` lines containing `: gone]`), using `git branch -D`. Skips `main`, `master`, and your current branch. Lists branches before asking; if none match, exits without a prompt.

```bash
git forget
git forget -n
```

## Shell aliases and functions

### Navigation and misc (both platforms)

| Alias / function | Action |
| --- | --- |
| `~`, `home` | `cd ~` |
| `..`, `...`, `....` | Up 1–3 directories |
| `-` | `cd -` |
| `d`, `1`–`9` | Directory stack: list last 10 dirs; jump by number |
| `path` | Print `$PATH` one entry per line |
| `myip` | Public IP via OpenDNS |
| `sudo` | `sudo ` (trailing space so aliases work after `sudo`) |
| `extract <archive>` | Unpack `.tar.gz`, `.zip`, `.7z`, etc. (archive kept on disk) |
| `mkcd <dir>` | `mkdir -p` and `cd` into it |
| `rzsh` / `rzs` | Reload `~/.zshrc` |
| `c` | Open current directory in VS Code (`code .`) |
| `csr` | Open current directory in Cursor (`cursor .`) |
| `e:zshrc`, `e:alias`, `e:path`, `e:plugins`, `e:starship` | Open dotfiles paths in `code` |

Clipboard helpers (`copypath`, `copyfile`, `copyssh`) and listing aliases (`l`, `la`, `ll`, … via **eza**) are documented in the [README](../README.md#daily-workflow--shortcuts).

**bat** ([`config/bat/config`](../config/bat/config) → `~/.config/bat/config`): `style=full`, italic text, color, and decorations always on. Shell alias adds `--theme=OneHalfDark` and `--paging=never`; `cat` delegates to `bat` when installed.

### macOS only

| Alias | Action |
| --- | --- |
| `show` / `hide` | Show or hide dotfiles in Finder |
| `hide:desktop` / `show:desktop` | Toggle desktop icons |
| `localip` | LAN address on `en0` |

### Shell functions

| Function | Action |
| --- | --- |
| `cht <topic>` | Cheatsheet from [cht.sh](https://cht.sh) (e.g. `cht js/map+object`) |
| `bench-zsh [runs]` | Benchmark interactive Zsh startup (default 5 runs) |
| `rip` | `rm` without Trash (when `trash` is installed, plain `rm` uses Trash) |

## Custom commands (`~/bin`)

| Command | What it does |
| --- | --- |
| `whats-in-port <port>` | `lsof` of who is listening on that TCP port |
| `ytdl [-v\|-a] <url>` | Best video (mp4, default) or audio (mp3) via `yt-dlp` into `~/Downloads/youtube` |
| `ytdl-all` | Parallel downloads (`--jobs`, `--file`, `--audio`, `--dry-run`; see `ytdl-all --help`) |
| `$ <command>` | Runs the rest of a line pasted with a leading `$` |
| `dotfiles` | Re-runs `./install.sh` from this repo |
| `zsbrew` | macOS: `brew bundle` from `homebrew/Brewfile` (exits on Linux) |

**Dependencies**

| Tool | macOS | Linux (after `install.sh`) |
| --- | --- | --- |
| `ytdl` / `ytdl-all` | `yt-dlp`, `parallel`, `ffmpeg` from Brewfile | Install `yt-dlp` and GNU `parallel` yourself; apt step does not include them |
| `git *` helpers | `git` only | `git` only |