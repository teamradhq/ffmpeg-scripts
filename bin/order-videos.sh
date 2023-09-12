#!/bin/bash

###########################################################################################
#                                                                                         #
#   Order Videos                                                                          #
#                                                                                         #
#   This script will reorder all videos in the current directory that match a sequential  #
#   pattern.                                                                              #
#                                                                                         #
#   For example, if you have multiple video sequences, v1_001 - v1_nnn, v2_001            #
#   - v2_nnn, etc., this script will reorder them by sequence number.                     #
#                                                                                         #
#   So the originating order will be by video then sequence number, and the resulting     #
#   order will be by sequence number then video.                                          #
#                                                                                         #
###########################################################################################

dir_path=$(pwd)
processed_dir="$dir_path/processed"
counter=1

mkdir -p $processed_dir

for file in $(ls $dir_path | grep -E '^v[0-9]+_[0-9]{3}\.mp4$' | sort -t "_" -k 2,2n -k 1,1); do
    new_name=$(printf "sequence_%03d.mp4" $counter)
    cp "$dir_path/$file" "$processed_dir/$new_name"
    counter=$((counter + 1))
done
