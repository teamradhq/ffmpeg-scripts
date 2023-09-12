#!/usr/bin/env bash

convert_to_relative() {
    local full_paths=("$@")
    local current_dir=$(pwd)
    local relative_paths=()

    for path in "${full_paths[@]}"; do
        relative_paths+=("${path#$current_dir/}")
    done

    echo "${relative_paths[@]}"
}


INDIVIDUAL_COVERAGE_DIR=$(pwd)"/coverage-individual"
COVERAGE_DIR=$(pwd)"/coverage"

mkdir -p $INDIVIDUAL_COVERAGE_DIR

for test_script in test/test-*.sh; do
    kcov $INDIVIDUAL_COVERAGE_DIR/$(basename $test_script) $test_script
done

mkdir -p $COVERAGE_DIR
kcov --merge $COVERAGE_DIR $INDIVIDUAL_COVERAGE_DIR/*

rm -rf $INDIVIDUAL_COVERAGE_DIR
