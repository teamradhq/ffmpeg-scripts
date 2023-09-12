#!/bin/bash

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

# Split each video into segments
for video in *.mp4; do
    ffmpeg -i "$video" -c:v copy -c:a copy -f segment -segment_time $SEGMENT_DURATION -reset_timestamps 1 "${video%.mp4}_%03d.mp4"
done

# Count the maximum number of segments produced from any video
MAX_SEGMENTS=$(ls v1_* 2>/dev/null | wc -l)

# Extract unique video prefixes (e.g., v1, v2, v3, ...)
VID_PREFIXES=$(ls v*_*.mp4 2>/dev/null | cut -d'_' -f1 | sort -u)

BATCH_SIZE=50  # Adjust this value based on how many files you want in a single batch

# Process videos in batches
for (( j=0; j<$MAX_SEGMENTS; j+=$BATCH_SIZE )); do

    JOIN_LIST=""
    FILTER_COMPLEX=""
    COUNTER=0

    for (( i=j; i<$(($j + $BATCH_SIZE)) && i<$MAX_SEGMENTS; i++ )); do
        for video in $VID_PREFIXES; do
            SEGMENT_NAME="${video}_$(printf "%03d" $i).mp4"
            if [ -f "$SEGMENT_NAME" ]; then
                JOIN_LIST+="-i $SEGMENT_NAME "
                FILTER_COMPLEX+="[$COUNTER:v]"
                let "COUNTER+=1"
            fi
        done
    done

    FILTER_COMPLEX+="concat=n=$COUNTER:v=1[v]"
    BATCH_OUTPUT="batch_$(printf "%03d" $(($j/$BATCH_SIZE))).mp4"

    # Concatenate this batch's videos
    ffmpeg $JOIN_LIST -filter_complex "$FILTER_COMPLEX" -map "[v]" -r 30 "$BATCH_OUTPUT"
done

# Now, concatenate the batch outputs
ffmpeg $(for f in batch_*.mp4; do echo -n "-i $f "; done) -filter_complex "concat=n=$(ls batch_*.mp4 | wc -l):v=1[a]" -map "[a]" output.mp4

# Clean up temporary segments and batch outputs
rm v*_*
rm batch_*.mp4

echo "Process completed: output.mp4"