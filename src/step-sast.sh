#!/usr/bin/env psh
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
PROJECT="${INPUT_PROJECT_PATH:-.}"

if command -v pipery-steps &>/dev/null; then
  pipery-steps sast \
    --language rust \
    --project-path "$PROJECT" \
    --log-file "$LOG"
  exit 0
fi

if command -v cargo-audit &>/dev/null; then
  echo "pipery-steps not available, falling back to cargo audit."
  cd "$PROJECT"
  cargo audit
  exit 0
fi

echo "pipery-steps and cargo-audit not available, skipping SAST."
