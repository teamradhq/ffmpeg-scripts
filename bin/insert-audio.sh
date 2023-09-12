#!/usr/bin/env bash

###############################################################################
#                                                                             #
#   Insert Audio                                                              #
#                                                                             #
#   This script will insert the provided audio into the provided video file.  #
#   This will be output to a new file appended with "_with_new_audio".        #
#                                                                             #
###############################################################################

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <video_file> <audio_file>"
    exit 1
fi

FILE_NAME=$(basename -- "$1")
BASE_NAME="${FILE_NAME%.*}"

OUTPUT="$BASE_NAME"_with_new_audio.mp4

ffmpeg -i "$1" -i "$2" -c:v copy -c:a aac -strict experimental -map 0:v:0 -map 1:a:0 "$OUTPUT"

echo "Output created: $OUTPUT"
