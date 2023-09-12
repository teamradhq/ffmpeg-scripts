#!/usr/bin/env bash
DIR="$(dirname "$0")"
PATH="$PATH:$(realpath "$DIR/../bin")"
FIXTURE_DIR=$(realpath "$DIR/fixtures")

source "$DIR/functions.sh"

setUp()
{
  cd "$FIXTURE_DIR"
}

test_exit_if_no_arguments_passed()
{
  output=$(concat-videos.sh)
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
  generate_test_video v_001.mp4 black
  generate_test_video v_002.mp4 white

  concat-videos.sh v > /dev/null 2>&1
  actual=$?

  assertEquals 0 "${actual}"
  assertTrue "output.mp4 was not created" "[ -f \"$FIXTURE_DIR/output.mp4\" ]"
}

tearDown() {
  rm -f "$FIXTURE_DIR/v_001.mp4"
  rm -f "$FIXTURE_DIR/v_002.mp4"
  rm -f "$FIXTURE_DIR/output.mp4"
}

. shunit2
