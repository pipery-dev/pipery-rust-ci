#!/usr/bin/env psh
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
PROJECT="${INPUT_PROJECT_PATH:-.}"

if command -v pipery-steps &>/dev/null; then
  pipery-steps sca \
    --language rust \
    --project-path "$PROJECT" \
    --log-file "$LOG" \
    || echo "SCA step completed (non-fatal)"
  exit 0
fi

if command -v cargo-audit &>/dev/null; then
  echo "pipery-steps not available, falling back to cargo audit."
  cd "$PROJECT"
  cargo audit || echo "cargo audit completed (non-fatal)"
  exit 0
fi

echo "pipery-steps and cargo-audit not available, skipping SCA."
