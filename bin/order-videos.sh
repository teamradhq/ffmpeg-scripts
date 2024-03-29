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

# Default values
DROP_FILES=false
DIR_PATH=$(pwd)/processed
OUT_DIR=$(realpath "$DIR_PATH")
PREFIX="sequence"

args=()
for arg; do
  case "$arg" in
    --drop-files) args+=("-d");;
    --out-dir=*) args+=("-o" "${arg#*=}");;
    --prefix=*) args+=("-p" "${arg#*=}");;
    *) args+=("$arg");;
  esac
done

set -- "${args[@]}"

while getopts "do:p:" opt; do
    case $opt in
        d) DROP_FILES=true;;
        o) OUT_DIR=$(realpath "$OPTARG");;
        p) PREFIX="$OPTARG";;
        *) echo "Invalid option: -$OPTARG" >&2
           exit 1;;
    esac
done

DIR_PATH=$(pwd)
COUNTER=1

mkdir -p "$OUT_DIR"

do-file() {
    if $DROP_FILES; then
        mv "$1" "$2"
    else
        cp "$1" "$2"
    fi
}

mapfile -t files < <(find "$DIR_PATH" -type f -name 'v[0-9]*_[0-9][0-9][0-9].mp4' | sort -t "_" -k 2,2n -k 1,1)

for file in "${files[@]}"; do
    NEW_NAME=$(printf "${PREFIX}_%03d.mp4" $COUNTER)
    do-file "$file" "$OUT_DIR/$NEW_NAME"
    COUNTER=$((COUNTER + 1))
done

echo "Finished ordering videos by sequence number"

if $DROP_FILES; then
    echo "Source files removed"
else
    echo "Source files preserved"
fi
