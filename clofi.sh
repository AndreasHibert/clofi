#!/bin/bash

# ----------------------------------------------------------------------------
# 
# 
# 
# ----------------------------------------------------------------------------
# Prerequisites:
# yt-dlp (https://github.com/yt-dlp/yt-dlp)
# mpv (https://github.com/mpv-player/mpv)
# tmux (https://github.com/tmux/tmux)
# cava (https://github.com/karlstav/cava)

CLEAR='\033[0m'
RED='\033[0;31m'

# Array for preconfigred streams
declare -A url_map
url_map["-hiphop"]="https://www.youtube.com/watch?v=jfKfPfyJRdk"
url_map["-adhd"]="https://www.youtube.com/watch?v=CmMrm4BpQHU"
url_map["-chill"]="https://www.youtube.com/embed/AzwgsZUcTfM"
url_map["-focus"]="https://www.youtube.com/watch?v=aepL6kuX4dM"
url_map["-stress"]="https://www.youtube.com/watch?v=P7nu1o-mG_4"
url_map["-study"]="https://www.youtube.com/watch?v=3rmWJAQ0Na4"
url_map["-jazz"]="https://www.youtube.com/watch?v=MOKnTxzU4z0"
url_map["-study2"]="https://www.youtube.com/watch?v=GjRMW4EcRAE"


# Function to select a random video
select_random_url() {
    local urls=("${!url_map[@]}") # Retrieve all keys from the array
    local random_key=${urls[$RANDOM % ${#urls[@]}]} # Select a random key
    URL=${url_map[$random_key]} # Set URL to the value corresponding to the random key
}


usage() {
  if [ -n "$1" ]; then
    echo -e "${RED}👉 $1${CLEAR}\n"
  fi
  
  cat << EOF
  Usage: $(basename "$0") [options]
    -h, --help     Show this message
    -u, --url      specific URL
    -a, --audio    Audio only
    -r, --random   random stream
    -c, --cava     Enable visualization mode (mpv audio only + cava)
  
    ------------------------------------------
  
  preconfigured streams:

    -hiphop        lofi hip hop radio
    -adhd          ADHD Relief Music
    -chill         Summer Chill
    -focus         Deep Focus Music
    -stress        Stress and Anxiety Reduction
    -study         Music for Studying
    -study2        Ambient Music for Studying
    -jazz          Warm Jazz Music for Studying
  
  Examples: $(basename "$0") --audio -u "https://www.youtube.com/watch?v=jfKfPfyJRdk"
            $(basename "$0") -c -adhd
EOF
}

# Check if mpv is running. If it is, kill it and exit the script.
# this was added if you want to use this script with a keybind
if pgrep mpv > /dev/null; then
    echo "mpv is currently running. Stopping mpv..."
    killall mpv
    killall cava
    exit 0
fi

# parse params
while [[ "$#" -gt 0 ]]; do case $1 in
      -h|--help)   usage; exit 0 ;;
      -u|--url)    URL="$2"; shift; shift ;;
      -a|--audio)  AUDIO=1; shift ;;
      -r|--random) select_random_url; shift ;;
      -c|--cava)   CAVA=1; shift ;;
      *)           
          if [[ ${url_map[$1]+_} ]]; then
                URL="${url_map[$1]}"
                shift
            else
                usage "Unknown parameter passed: $1"; exit 1
            fi
            ;;
esac; done

# if no URL is spcified the default lofi youtube link will be used
if [ -z "$URL" ]; then
  echo "No URL specified using default URL"
  URL="https://www.youtube.com/watch?v=jfKfPfyJRdk"
fi

# Generate a unique session ID for the tmux session
SESSION_ID="clofi"

cleanup() {
  echo "Terminating tmux session $SESSION_ID..."
  tmux kill-session -t $SESSION_ID
  exit 0  # Cleanly exit the script
}

# Set up a trap statement that calls cleanup when the script receives a SIGINT or SIGHUP signal
if [ -n "$CAVA" ]; then
  trap cleanup SIGINT SIGHUP
fi

# start cava
if [ -n "$CAVA" ]; then
  # Start the tmux session with the unique SESSION_ID
  tmux new-session -d -s $SESSION_ID "yt-dlp '$URL' -f best -o - | mpv -vo null -"
  # Start cava
  cava
elif [ -n "$AUDIO" ]; then
  # start audio only
  yt-dlp "$URL" -f best -o - | mpv -vo null -
else
  # else, play the video inline directly in the terminal with colors
  yt-dlp --quiet --no-warnings "$URL" -f best -o - | mpv --vo=tct --really-quiet -
fi

exit 0
