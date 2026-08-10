## Custom binaries

### dotfiles

This binary simply installs/updates dotfiles

### zsbrew

This binary install contents of $DOTFILES/homebrew/Brewfile

### transcribe

Symlink to the dev repo at `~/Documents/dev/transcribe/transcribe.sh`. Edits in the repo are picked up immediately.

```sh
transcribe --help
transcribe --subtitles "https://www.youtube.com/watch?v=VIDEO_ID"
transcribe podcast.mp3
```

Re-link after moving the repo:

```sh
ln -sf /path/to/transcribe/transcribe.sh ~/.dotfiles/bin/bin/transcribe
ln -sf /path/to/transcribe/transcribe.sh ~/bin/transcribe
```

### ytdl

This binary helps with downloading best quality audio or video

check help for usage:
```sh
ytdl --help
```

### ytdl-all

Parallel multi-URL downloader (`yt-dlp` + GNU `parallel`):

```sh
ytdl-all --help
ytdl-all --jobs 3 "URL1" "URL2"
ytdl-all --file urls.txt -j 4
```

### whats-in-port

Useful to check what runs on a given port

### $

Useful when you copy commands from internet like a total psycho and you get `-zsh: $: command not found`
