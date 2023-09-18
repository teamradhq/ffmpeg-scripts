#!/usr/bin/env bash
DIR="$(dirname "$0")"
BIN_DIR=$(realpath "$DIR/../bin")
PATH="$PATH:$BIN_DIR"
FIXTURE_DIR=$(realpath "$DIR/fixtures")
SPLIT_DIR="$FIXTURE_DIR/split"
SPLIT_FILE="$SPLIT_DIR/v01_000.mp4"

source "$DIR/functions.sh"

setUp()
{
  cd "$FIXTURE_DIR"
  generate_test_video v_001.mp4 black
  generate_test_video v_002.mp4 white
}

test_exit_if_no_arguments_passed()
{
  output=$("$BIN_DIR/split-videos.sh")
  actual=$?

  if [[ $output == "Usage: "* ]]; then
      starts_with="true"
  else
      starts_with="false"
  fi

  assertEquals "true" "${starts_with}"
  assertEquals 1 "${actual}"
}

test_split_files_are_generated()
{
  "$BIN_DIR/split-videos.sh" 60 1 > /dev/null 2>&1
  actual=$?

  assertEquals 0 "${actual}"
  assertTrue "split directory was not created" "[ -d \"$SPLIT_DIR\" ]"
  assertTrue "split files were not created" "[ -f \"$SPLIT_FILE\" ]"

  local expected_count=60
  local actual_count
  actual_count=$(find "$SPLIT_DIR" -maxdepth 1 -type f | wc -l)

  local duration
  duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${SPLIT_FILE}" | awk '{print int($1+0.5)}')

  assertEquals "Unexpected number of files in $SPLIT_DIR" $expected_count $actual_count
  assertEquals "Expected split file to be 1 second long" 1 "$duration"
}

tearDown() {
  rm -rf \
    "$FIXTURE_DIR/v_001.mp4" \
    "$FIXTURE_DIR/v_002.mp4" \
    "$FIXTURE_DIR/split"
}

. shunit2
