# clofi

clofi is a cli lofi player.

## Dependencies

**Disclaimer:** only testet on Arch but should work an any Unix like system. If you run it while it is already running it will kill all mpv and cava sessions. Helpfull if you bind it to a key.

- [mpv](https://github.com/mpv-player/mpv)

- [tmux](https://github.com/tmux/tmux)

- [yt-dlp](https://github.com/yt-dlp/yt-dlp)

- [cava](https://github.com/karlstav/cava)

## Installation

Just copy and run `clofi.sh`

## Usage

There are a few preconfigured youtube live streams for a full list run `clofi -h`.

### Examples

```bash
# use default youtube link and video in the cli
clofi

# use a specific youtube link
clofi -u "https://..."

# use a preconfigred youtube link
clofi -adhd

# use cava insted of the video
clofi -c

# audio only (if you want to bind it to a key)
clofi -a

# run a random preconfigred youtube link and cava
clofi -r -c
```

![](clofi.gif)
