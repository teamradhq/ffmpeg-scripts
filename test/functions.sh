
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