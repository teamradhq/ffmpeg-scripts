#!/usr/bin/env bash

# Remove the provided keys from the json
json_excluding_keys() {
  local json=$1
  shift
  for key; do
    json=$(echo "$json" | jq "del(.exif.${key})")
  done
  echo "$json"
}



test_exit_if_no_arguments_passed()
{
  output=$(./bin/extract-tags.sh)
  actual=$?

  if [[ $output == "Usage: "* ]]; then
      starts_with="true"
  else
      starts_with="false"
  fi

  assertEquals "true" "${starts_with}"
  assertEquals 1 "${actual}"
}

test_exit_if_file_does_not_exist()
{
  output=$(./bin/extract-tags.sh missing.mp3)
  actual=$?

  assertEquals "File not found: missing.mp3" "${output}"
  assertEquals 2 "${actual}"
}

test_mp3_json_is_correct() {
  actual=$(./bin/extract-tags.sh ./test/mp3-example.mp3 | jq -c .)
  expected=$(jq -c . < ./test/mp3-example.json)

  keys_to_exclude=(
    "ExifToolVersion"
    "FileSize"
    "FileModifyDate"
    "FileAccessDate"
    "FileInodeChangeDate"
    "FilePermissions"
  )

  actual=$(json_without_specified_keys "$actual" "${keys_to_exclude[@]}")
  expected=$(json_without_specified_keys "$expected" "${keys_to_exclude[@]}")

  assertEquals "${expected}" "${actual}"
}

. shunit2
