#!/usr/bin/env bash

#######################################################################
#                                                                     #
#   Extract Tags                                                      #
#                                                                     #
#   Extract exif and id3 metadata from the given file in JSON format. #
#                                                                     #
#######################################################################

if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "File not found: $1"
    exit 2
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILE_PATH="$1"

EXIF_OUTPUT=$(exiftool -j "$FILE_PATH") || exit 4
ID3_OUTPUT=$("$SCRIPT_DIR/extract-id3-tags.sh" "$FILE_PATH") || exit 4
JSON=$(jq -n --argjson exif "$EXIF_OUTPUT" --argjson id3 "$ID3_OUTPUT" '{exif: $exif[0], id3: $id3}')

echo "$JSON" | jq .