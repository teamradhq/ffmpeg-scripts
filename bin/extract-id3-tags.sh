#!/usr/bin/env bash

#########################################################################################
#                                                                                       #
#   Extract Id3 Tags                                                                    #
#                                                                                       #
#   This script will attempt to extract Id3 tags from the provided file using id3info.  #
#   Additionally, an awk script converts the output to JSON format.                     #
#                                                                                       #
#########################################################################################

if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Exit if the file doesn't exist
if [ ! -f "$1" ]; then
    echo "File not found: $1"
    exit 2
fi


FILEPATH="$1"
FILENAME=$(basename -- "$FILEPATH")
EXTENSION="${FILENAME##*.}"

if [[ ! "$EXTENSION" =~ ^(mp3|aiff|wav|mp4|m4a|ogg|flac|dsf|dff)$ ]]; then
    echo "The file does not have an extension that could contain ID3 tags."
    exit 1
fi

id3info "$FILEPATH" | awk '
BEGIN {
    print "{";
    RS="\n";
    FS=":";
    is_first = 1;
}
$1 ~ /^===/ {
    if (!is_first) {
        print ",";
    } else {
        is_first = 0;
    }
    gsub(/^=== /, "", $1);  # Remove "=== " prefix
    gsub(/ $/, "", $1);     # Remove trailing spaces
    gsub(/^ /, "", $2);     # Remove leading spaces
    printf "    \"%s\": \"%s\"", $1, $2;
}
$1 ~ /^\*\*\* mp3 info$/ {
    if (!is_first) {
        print ",";
    }
    print "\n    \"mp3_info\": {";
    is_first = 1;
}
$1 ~ /^Bitrate/ || $1 ~ /^Frequency/ {
    if (!is_first) {
        print ",";
    } else {
        is_first = 0;
    }
    printf "        \"%s\": \"%s\"", $1, $2;
}
END {
    print "\n    }";
    print "}";
}'

exit