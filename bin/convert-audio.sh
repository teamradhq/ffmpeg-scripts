#!/usr/bin/env bash
#########################################################################################
#                                                                                       #
#   Convert Audio Files                                                                 #
#                                                                                       #
#   Provide this script with a file pattern to match and a target format to convert to  #
#   and ffmpeg will convert all matching files to the target format.                    #
#                                                                                       #
#########################################################################################


# Check for a valid number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_pattern> <output_format>"
    exit 1
fi

INPUT_PATTERN=$1
OUTPUT_FORMAT=$2
ALLOWED_FORMATS=("aiff" "wav" "flac" "alac" "caf" "m4a")  # Add or remove allowed formats as needed

# Check if the provided output format is in the allowed list using a loop
is_format_valid=0  # False

for format in "${ALLOWED_FORMATS[@]}"; do
    if [[ "$format" == "$OUTPUT_FORMAT" ]]; then
        is_format_valid=1  # True
        break
    fi
done

if [[ $is_format_valid -eq 0 ]]; then
    echo "Error: Unsupported format ${OUTPUT_FORMAT}"
    echo "Supported formats: ${ALLOWED_FORMATS[@]}"
    exit 1
fi

# Determine the codec and potentially adjust the output format based on the desired output format
case $OUTPUT_FORMAT in
    "alac")
        CODEC="alac"
        OUTPUT_FORMAT="m4a"
        ;;
    "m4a")
        CODEC="aac"
        ;;
    # Add more cases if needed for specific codecs
    *)
        CODEC=""
        ;;
esac

# Process the matching files
for FILE in $INPUT_PATTERN; do
    if [[ -f $FILE ]]; then
        BASE=$(basename "$FILE")
        FILE_EXTENSION="${BASE##*.}"
        FILENAME="${BASE%.*}"

        # Skip if the input file is already in the target format
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
