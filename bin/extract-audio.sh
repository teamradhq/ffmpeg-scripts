#!/usr/bin/env bash

#################################################################################
#                                                                               #
#   Extract Audio                                                               #
#                                                                               #
#   This script will extract the audio from the provided video in AIFF format.  #
#                                                                               #
#   For example, if your video is video.mp4, this script will create a file     #
#   called video.aiff which contains the audio from the video.                  #
#                                                                               #
#################################################################################

if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

FILE_NAME=$(basename -- "$1")
BASE_NAME="${FILE_NAME%.*}"

ffmpeg -i "$1" -vn -c:a pcm_s16be "$BASE_NAME.aiff"

echo "Audio extracted to: $BASE_NAME.aiff"
