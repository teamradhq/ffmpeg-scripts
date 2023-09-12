#!/usr/bin/env bash

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

DIR_PATH=$(pwd)
OUT_DIR="$DIR_PATH/processed"
COUNTER=1

mkdir -p $OUT_DIR

for file in $(ls $DIR_PATH | grep -E '^v[0-9]+_[0-9]{3}\.mp4$' | sort -t "_" -k 2,2n -k 1,1); do
    NEW_NAME=$(printf "sequence_%03d.mp4" $COUNTER)
    cp "$DIR_PATH/$file" "$OUT_DIR/$NEW_NAME"
    COUNTER=$((COUNTER + 1))
done
