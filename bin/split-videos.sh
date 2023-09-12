#!/bin/bash

#########################################################################################
#                                                                                       #
#   Split Videos                                                                        #
#                                                                                       #
#   This script will split all videos in the current directory into segments of a       #
#   specified duration. The duration is specified by giving a tempo in BPM and the      #
#   number of beats per segment.                                                        #
#                                                                                       #
#   For example, if you call `split-videos.sh 60 1` then the videos will be split       #
#   at 1 second intervals.                                                              #
#                                                                                       #
#   Split videos are output to the `split` directory.                                   #
#                                                                                       #
#########################################################################################

# Check for the right number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 {TEMPO} {BEATS}"
    exit 1
fi

ulimit -n 8192

# Given inputs from arguments
TEMPO=$1
BEATS=$2

# Calculate segment duration in seconds
SEGMENT_DURATION=$(bc <<< "scale=5; (60 / $TEMPO) * $BEATS")

# Check if segment duration is less than 1 and format accordingly
if (( $(echo "$SEGMENT_DURATION < 1" | bc -l) )); then
    SEGMENT_DURATION="0$SEGMENT_DURATION"
fi

mkdir -p split
# Split each video into segments
for video in *.mp4; do
    ffmpeg -i "$video" -c:v copy -c:a copy -f segment -segment_time $SEGMENT_DURATION -reset_timestamps 1 "split/${video%.mp4}_%03d.mp4"
done

echo "Split videos into timed segments..."