#!/bin/bash

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

# Check if the input argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Extract the filename without extension
filename=$(basename -- "$1")
basename="${filename%.*}"

# Use ffmpeg to extract and convert audio to AIFF
ffmpeg -i "$1" -vn -c:a pcm_s16be "$basename.aiff"

echo "Audio extracted to: $basename.aiff"
