#!/usr/bin/env bash
#########################################################################################
#                                                                                       #
#   Convert Audio Files                                                                 #
#                                                                                       #
#   Provide this script with a file pattern to match and a target format to convert to  #
#   and ffmpeg will convert all matching files to the target format.                    #
#                                                                                       #
#########################################################################################

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_pattern> <output_format>"
    exit 1
fi

INPUT_PATTERN=$1
OUTPUT_FORMAT=$2
ALLOWED_FORMATS=("aiff" "wav" "flac" "alac" "caf" "m4a")


IS_FORMAT_VALID=0
for FORMAT in "${ALLOWED_FORMATS[@]}"; do
    if [[ "$FORMAT" == "$OUTPUT_FORMAT" ]]; then
        IS_FORMAT_VALID=1
        break
    fi
done

if [[ $IS_FORMAT_VALID -eq 0 ]]; then
    echo "Error: Unsupported format ${OUTPUT_FORMAT}"
    echo "Supported formats: " "${ALLOWED_FORMATS[@]}"
    exit 1
fi

case $OUTPUT_FORMAT in
    "alac")
        CODEC="alac"
        OUTPUT_FORMAT="m4a"
        ;;
    "m4a")
        CODEC="aac"
        ;;
    *)
        CODEC=""
        ;;
esac

for FILE in $INPUT_PATTERN; do
    if [[ -f $FILE ]]; then
        BASE=$(basename "$FILE")
        FILE_EXTENSION="${BASE##*.}"
        FILENAME="${BASE%.*}"

        if [[ "$FILE_EXTENSION" == "$OUTPUT_FORMAT" ]]; then
            echo "Skipping $FILE, already in target format."
            continue
        fi

        OUTPUT_FILE="${FILENAME}.${OUTPUT_FORMAT}"
        echo "Converting $FILE to $OUTPUT_FILE..."

        if [[ -n $CODEC ]]; then
            ffmpeg -i "$FILE" -acodec "$CODEC" -vn "$OUTPUT_FILE"
        else
            ffmpeg -i "$FILE" -vn "$OUTPUT_FILE"
        fi
    fi
done
