#!/usr/bin/env bash
DIR="$(dirname "$0")"
BIN_DIR=$(realpath "$DIR/../bin")
PATH="$PATH:$BIN_DIR"
FIXTURE_DIR=$(realpath "$DIR/fixtures")

source "$DIR/functions.sh"

setUp()
{
  cd "$FIXTURE_DIR"
  generate_test_video v_001.mp4 black
  generate_test_video v_002.mp4 white
}

test_exit_if_no_arguments_passed()
{
  output=$($BIN_DIR/concat-videos.sh)
  actual=$?

  if [[ $output == "Usage: "* ]]; then
      starts_with="true"
  else
      starts_with="false"
  fi

  assertEquals "true" "${starts_with}"
  assertEquals 1 "${actual}"
}

test_output_file_is_generated()
{
  $BIN_DIR/concat-videos.sh v > /dev/null 2>&1
  actual=$?
  FILE="$FIXTURE_DIR/output.mp4"

  assertEquals 0 "${actual}"
  assertTrue "output.mp4 was not created" "[ -f \"$FILE\" ]"

  local duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${FILE}" | awk '{print int($1+0.5)}')

  assertEquals 60 "$duration"
}

test_output_option_is_used() {
    for option in "--output" "-o"; do
        $BIN_DIR/concat-videos.sh v $option concat.mp4 > /dev/null 2>&1
        FILE="$FIXTURE_DIR/concat.mp4"

        assertEquals "Failed with option $option" 0 "${actual}"
        assertTrue "concat.mp4 was not created using $option" "[ -f \"$FILE\" ]"

        rm -f "$FILE"
    done
}

test_prefix_option_is_used()
{
    for option in "--prefix" "-p"; do
        $BIN_DIR/concat-videos.sh --prefix v > /dev/null 2>&1
        FILE="$FIXTURE_DIR/output.mp4"

        assertEquals "Failed with option $option" 0 "${actual}"
        assertTrue "output.mp4 was not created using $option" "[ -f \"$FILE\" ]"

        rm -f "$FILE"
    done
}

tearDown() {
  rm -f \
    "$FIXTURE_DIR/v_001.mp4" \
    "$FIXTURE_DIR/v_002.mp4" \
    "$FIXTURE_DIR/output.mp4" \
    "$FIXTURE_DIR/concat.mp4"
}

. shunit2
