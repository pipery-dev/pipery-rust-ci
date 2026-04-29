#!/usr/bin/env psh
set -euo pipefail

PROJECT="${INPUT_PROJECT_PATH:-.}"
LOG="${INPUT_LOG_FILE:-pipery.jsonl}"

if command -v pipery-steps &>/dev/null; then
  NEW_VERSION=$(pipery-steps version \
    --language rust \
    --project-path "$PROJECT" \
    --bump "${INPUT_VERSION_BUMP:-patch}")
  echo "New version: $NEW_VERSION"
  [ -n "${GITHUB_OUTPUT:-}" ] && echo "version=$NEW_VERSION" >> "$GITHUB_OUTPUT"
  printf '{"event":"version","status":"success","version":"%s"}\n' "$NEW_VERSION" >> "$LOG"
  exit 0
fi

# Fallback: bump Cargo.toml manually
CARGO_TOML="$PROJECT/Cargo.toml"
if [ ! -f "$CARGO_TOML" ]; then
  echo "Cargo.toml not found at $CARGO_TOML, skipping versioning."
  exit 0
fi

CURRENT=$(grep -E '^version\s*=' "$CARGO_TOML" | head -1 | sed 's/.*"\(.*\)".*/\1/')
if [ -z "$CURRENT" ]; then
  echo "Could not parse current version from Cargo.toml, skipping versioning."
  exit 0
fi

BUMP="${INPUT_VERSION_BUMP:-patch}"
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT"
case "$BUMP" in
  major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
  minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
  *)     PATCH=$((PATCH + 1)) ;;
esac
NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"

sed -i.bak "s/^version = \"${CURRENT}\"/version = \"${NEW_VERSION}\"/" "$CARGO_TOML"
rm -f "${CARGO_TOML}.bak"

echo "Version bumped: ${CURRENT} -> ${NEW_VERSION}"
[ -n "${GITHUB_OUTPUT:-}" ] && echo "version=${NEW_VERSION}" >> "$GITHUB_OUTPUT"
printf '{"event":"version","status":"success","version":"%s"}\n' "$NEW_VERSION" >> "$LOG"
