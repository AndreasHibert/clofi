# clofi

clofi is a fork from [ytplay](https://github.com/raphtlw/dotfiles/blob/master/bin/ytplay).

since youtube-dl is not maintained anymore I changed this script to yt-dlp

I rewrote the script to my needs.



I have configred a few default lofi like streams. feel free to modify it to your needs.

example `clofi -hiphop` will run this URL `https://www.youtube.com/watch?v=jfKfPfyJRdk`  or `clofi -a -adhd` to run this URL with audio only `https://www.youtube.com/watch?v=CmMrm4BpQHU`.

to see the whole list just run `clofi -h`



copy the file to `/usr/local/bin` and set a keybind in your WM to `clofi -a` , and everytime you press your keybind the script will start playing the default or given youtube URL in the backgroud. Press again to kill mpv.

or you can use clofi directly in the CLI if you want to have a pixelated video from the youtube video.



example:
![](clofi.gif)
