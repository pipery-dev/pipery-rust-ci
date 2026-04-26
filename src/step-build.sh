#!/usr/bin/env psh
set -euo pipefail

PROJECT="${INPUT_PROJECT_PATH:-.}"

cd "$PROJECT"

BUILD_ARGS="--release"

if [ -n "${INPUT_TARGET:-}" ]; then
  BUILD_ARGS="$BUILD_ARGS --target ${INPUT_TARGET}"
fi

if [ -n "${INPUT_FEATURES:-}" ]; then
  BUILD_ARGS="$BUILD_ARGS --features ${INPUT_FEATURES}"
fi

cargo build $BUILD_ARGS

mkdir -p dist

if [ -n "${INPUT_TARGET:-}" ]; then
  find "target/${INPUT_TARGET}/release" -maxdepth 1 -type f -executable \
    ! -name '*.d' ! -name '*.rlib' ! -name '*.so' ! -name '*.a' \
    -exec cp {} dist/ \; 2>/dev/null || true
else
  find target/release -maxdepth 1 -type f -executable \
    ! -name '*.d' ! -name '*.rlib' ! -name '*.so' ! -name '*.a' \
    -exec cp {} dist/ \; 2>/dev/null || true
fi

echo "Build complete. Artifacts in dist/:"
ls dist/ 2>/dev/null || true
