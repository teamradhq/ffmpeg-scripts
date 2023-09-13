#!/usr/bin/env bash

#########################################################################################
#                                                                                       #
#  This example will split a set of videos in the cwd named v1.mp4, v2.mp4, ... vn.mp4  #
#  It will reorder them by sequence number then video. Then it combines all sequences   #
#  into a single video:                                                                 #
#                                                                                       #
#   Usage:                                                                              #
#     split-and-combine-videos {tempo} {beats} {output-file}                            #
#     split-and-combine-videos 120 1 ./demo/example-120-1beat.mp4                       #
#                                                                                       #
#########################################################################################

BIN_DIR="$(dirname "$0")"
BIN_DIR=$(realpath "$BIN_DIR/../bin")

PATH="$PATH:$BIN_DIR"
CWD=$(pwd)
TEMPO=$1
BEATS=$2
OUT_FILE=$(realpath $3)

cleanup() {
  rm -rf processed split
}

error() {
  echo "$1"
  cleanup
  exit 1
}

cleanup
split-videos.sh $TEMPO $BEATS \
  || error "Failed to split videos"

(cd "$CWD/split" && order-videos.sh) \
  || error "Failed to order videos"

(mv "$CWD/split/processed" "$CWD") \
  || error "Failed to move reordered videos"

(cd "$CWD/processed" && concat-videos.sh -p sequence -o "$OUT_FILE") \
  || error "Failed to join videos"

cleanup

