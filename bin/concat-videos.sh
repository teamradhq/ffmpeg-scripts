#!/usr/bin/env bash

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
#  into a single file called "output.mp4" or whatever you specify for --output.         #
#                                                                                       #
#########################################################################################

PREFIX=""
OUTPUT="output.mp4"

if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <prefix> OR $0 [-p|--prefix prefix] [-o|--output outputfile.mp4]"
  exit 1
fi

if [[ ! "$1" =~ ^- ]]; then
  PREFIX="$1"
  shift
fi

for arg in "$@"; do
  case "$arg" in
    --prefix)
      args="${args}-p "
      ;;
    --output)
      args="${args}-o "
      ;;
    *)
      args="${args}$arg "
      ;;
  esac
done

eval set -- "$args"

while getopts "p:o:" opt; do
  case "$opt" in
    p) PREFIX="$OPTARG";;
    o) OUTPUT="$OPTARG";;
    *)
      echo "Unknown option: -$OPTARG"
      exit 1
      ;;
  esac
done

if [ -z "$PREFIX" ]; then
  echo "Prefix is required. Use positional argument or -p|--prefix option."
  exit 1
fi

OUTPUT=$(realpath $OUTPUT)
LIST=concat_list.txt

rm -f $LIST

for f in $(ls ${PREFIX}_*.mp4 | sort -V); do
  echo "file '$f'" >> $LIST
done

ffmpeg -f concat -safe 0 -i $LIST -c copy "$OUTPUT"
echo "Saved to $OUTPUT";
rm -f $LIST
