#!/usr/bin/env psh
set -euo pipefail

PROJECT="${INPUT_PROJECT_PATH:-.}"
LOG="${INPUT_LOG_FILE:-pipery.jsonl}"

cd "$PROJECT"

mkdir -p dist

cargo package --no-verify 2>/dev/null || cargo package

find target/package -maxdepth 1 -name '*.crate' -exec cp {} dist/ \; 2>/dev/null || true

echo "Package complete. Artifacts in dist/:"
ls dist/ 2>/dev/null || true
printf '{"event":"package","status":"success"}\n' >> "$LOG"
