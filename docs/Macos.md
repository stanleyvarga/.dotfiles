# macOS — dotfiles behavior

What this checkout configures on **macOS** after `./install.sh`. Git, aliases, and `~/bin` commands: [Commands.md](./Commands.md). `config/` symlink layout matches [Linux.md](./Linux.md).

## Install

- Homebrew: [`homebrew/Brewfile`](../homebrew/Brewfile) when packages are missing (`zsbrew` for a full sync).
- Symlinks: same `config/` → `~/.config/` mapping as Linux.
- **Skip brew / login shell on re-run:**

```bash
SKIP_BREW_BUNDLE=1 SKIP_CHSH=1 ./install.sh
```

## Keyboard — Caps Lock → Control

Configured in [`macos/set-defaults`](../macos/set-defaults):

- LaunchAgent: repo [`macos/com.dotfiles.capslock-to-ctrl.plist`](../macos/com.dotfiles.capslock-to-ctrl.plist) → `~/Library/LaunchAgents/`
- Runs `hidutil` at login and once when you execute `set-defaults`
- **Revert:**

```bash
launchctl bootout "gui/$(id -u)/com.dotfiles.capslock-to-ctrl"
rm -f ~/Library/LaunchAgents/com.dotfiles.capslock-to-ctrl.plist
/usr/bin/hidutil property --set '{"UserKeyMapping":[]}'
```

## macOS defaults (`macos/set-defaults`)

Run manually when you want to apply or refresh (not run automatically from this repo on Linux CI).

| Area | What changes |
| --- | --- |
| **Key repeat** | Fast repeat; press-and-hold for accents off (`InitialKeyRepeat`, `KeyRepeat`, `ApplePressAndHoldEnabled`) |
| **Scrollbars** | Show when scrolling |
| **Screenshots** | PNG to `~/Desktop/Screenshots`, no window shadow |
| **Font smoothing** | `AppleFontSmoothing = 1` |
| **Finder** | List view, path bar, status bar, all extensions visible, no extension warning, `~/Library` unhidden |
| **Keyboard** | Full keyboard access (Tab through all controls) |
| **Text (system-wide)** | Smart quotes, smart dashes, and auto-correct **off** |
| **Dialogs** | Expanded save and print panels |
| **Network volumes** | No `.DS_Store` on network stores (`DSDontWriteNetworkStores`) |

The script does **not** call `killall Finder`. After running it, verify with `defaults read …`, then restart Finder yourself if Finder UI did not update.

## Homebrew additions

From the Brewfile (macOS):

- **`gh`** — GitHub CLI (`gh browse`, etc.). Credential helper for Git is **not** enabled by default; only add after `gh auth login` if you want it.
- **`shellcheck`** — lint shell scripts (`install.sh`, `bin/bin/*`).
- **`yt-dlp`**, **`parallel`**, **`ffmpeg`** — required for `ytdl` / `ytdl-all` (see [Commands.md](./Commands.md)).

## Wallpapers (`wp-ngn` / `wpp`)

Same program, two names. `--dynamic` picks a file from `~/Wallpapers/{night,dawn,sunrise,morning,afternoon,sunset,dusk}/` using the current month’s clock. Other modes: `--random`, `--screens`, `--sync-screens`.

`jq` is in the Brewfile. The `wallpaper` CLI is not; install it separately. [`bin/bin/install-external`](../bin/bin/install-external) clones `wallpaper-ngn` and replaces `bin/bin/wp-ngn` with that checkout.

## Sleep and wake

`install.sh` links [`root/.sleep`](../root/.sleep) and [`root/.wakeup`](../root/.wakeup) to `~/.sleep` and `~/.wakeup`. `sleepwatcher` is in the Brewfile. Start the service yourself. The `wp-ngn --dynamic` line in `.wakeup` is commented out, so wake leaves the wallpaper alone until you uncomment it.

## Config paths

Same as [Linux — config paths](./Linux.md#config-paths-quick-reference) (includes `~/.config/bat/config`). On macOS, `Brewfile` also links to `~/Brewfile`.