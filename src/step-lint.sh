#!/usr/bin/env psh
set -euo pipefail

PROJECT="${INPUT_PROJECT_PATH:-.}"

cd "$PROJECT"

rustup component add clippy 2>/dev/null || true

if [ -n "${INPUT_FEATURES:-}" ]; then
  cargo clippy --features "${INPUT_FEATURES}" -- -D warnings
else
  cargo clippy -- -D warnings
fi

echo "Lint passed (cargo clippy)."
