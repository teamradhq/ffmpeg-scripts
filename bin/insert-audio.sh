#!/bin/bash

###############################################################################
#                                                                             #
#   Insert Audio                                                              #
#                                                                             #
#   This script will insert the provided audio into the provided video file.  #
#                                                                             #
###############################################################################

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <video_file> <audio_file>"
    exit 1
fi

filename=$(basename -- "$1")
basename="${filename%.*}"

output="$basename"_with_new_audio.mp4

ffmpeg -i "$1" -i "$2" -c:v copy -c:a aac -strict experimental -map 0:v:0 -map 1:a:0 "$output"

echo "Output created: $output"
