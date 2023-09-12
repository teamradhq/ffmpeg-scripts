
# Remove the provided keys from the json.
json_excluding_keys() {
  local json=$1
  shift
  for key; do
    json=$(echo "$json" | jq "del(.exif.${key})")
  done
  echo "$json"
}

# Remove unpredictable tags data from the json.
json_tag_data() {
  local json=$1

  keys_to_exclude=(
    "ExifToolVersion"
    "FileSize"
    "FileModifyDate"
    "FileAccessDate"
    "FileInodeChangeDate"
    "FilePermissions"
  )

  json_excluding_keys "$json" "${keys_to_exclude[@]}"
}

# Generate a test video file.
# generate_test_video black.mp4 black
# generate_test_video white.mp4 white
generate_test_video()
{
  local fileName=$1
  local color=$2
  ffmpeg -f lavfi -i color=c=$color:s=10x10:d=30 -c:v libx264 -t 30 "test/fixtures/$fileName"
}