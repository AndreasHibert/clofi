#!/bin/bash

# ----------------------------------------------------------------------------
# clofi is a fork from ytplay by https://github.com/raphtlw
# since youtube-dl is not maintained anymore I changed this script to yt-dlp
# I rewrote the script to my needs
# ----------------------------------------------------------------------------
# Dependencies:
# yt-dlp (https://github.com/yt-dlp/yt-dlp)
# mpv

CLEAR='\033[0m'
RED='\033[0;31m'

usage() {
  if [ -n "$1" ]; then
    echo -e "${RED}👉 $1${CLEAR}\n"
  fi
  
  cat << EOF
  Usage: $(basename "$0") [REQUIRED -u url] [options]
    -h, --help     Show this message
    -u, --url      (Required) URL
    --audio        Audio only
  
  Examples: $(basename "$0") --audio -u "https://www.youtube.com/watch?v=jfKfPfyJRdk"
EOF
}

# Check if mpv is running. If it is, kill it and exit the script.
if pgrep mpv > /dev/null; then
    echo "mpv is currently running. Stopping mpv..."
    killall mpv
    exit 0
fi

# parse params
while [[ "$#" -gt 0 ]]; do case $1 in
      -h|--help)   usage; exit 0 ;;
      -u|--url)    URL="$2"; shift; shift ;;
      --audio)     AUDIO=1; shift ;;
      *)           usage "Unknown parameter passed: $1"; exit 1 ;;
esac; done

if [ -z "$URL" ]; then
  usage "No URL specified using default URL"
  URL="https://www.youtube.com/watch?v=jfKfPfyJRdk"
fi

# The rest of the script will only run if mpv is not already running
if [ -n "$AUDIO" ]; then
  # if audio is specified
  yt-dlp "$URL" -f best -o - | mpv -vo null -
else
  # else, play the video inline directly in the terminal with colors
  until yt-dlp --quiet --no-warnings "$URL" -f best -o - | mpv --vo=tct --really-quiet -
  do
    echo "Stream has stopped, restarting..."
    sleep 1
  done
fi

exit 0
