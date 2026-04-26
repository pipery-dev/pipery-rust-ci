#!/usr/bin/env psh
set -euo pipefail

PROJECT="${INPUT_PROJECT_PATH:-.}"
TESTS_PATH="${INPUT_TESTS_PATH:-}"

cd "$PROJECT"

TEST_ARGS=""

if [ -n "${INPUT_FEATURES:-}" ]; then
  TEST_ARGS="$TEST_ARGS --features ${INPUT_FEATURES}"
fi

cargo test $TESTS_PATH $TEST_ARGS
