#!/bin/bash

#########################################################################################
#                                                                                       #
#   Concatenate Videos                                                                  #
#                                                                                       #
#   This script will concatenate all videos in the current directory that match the     #
#   prefix provided as an argument.                                                     #
#                                                                                       #
#   For example, if you have the following files:                                       #
#                                                                                       #
#           video_1.mp4, video_2.mp4, video_3.mp4, video_4.mp4                          #
#                                                                                       #
#  and you run this script with the prefix "video", it will concatenate all of them     #
#  into a single file called "output.mp4".                                              #
#                                                                                       #
#########################################################################################

# Check if a prefix argument was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <prefix>"
    exit 1
fi

# Define prefix from argument
prefix="$1"

# Create a list of files to concatenate
rm -f concat_list.txt
for f in $(ls ${prefix}_*.mp4 | sort -V); do
    echo "file '$f'" >> concat_list.txt
done

# Concatenate using ffmpeg
ffmpeg -f concat -safe 0 -i concat_list.txt -c copy output.mp4

# Cleanup the list
rm concat_list.txt