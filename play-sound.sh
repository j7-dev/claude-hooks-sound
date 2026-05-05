#!/usr/bin/env bash
# Cross-platform sound player for Claude Code hooks (macOS / Linux).
# Mirrors play-sound.ps1 — looks up ./sounds/<EventName>.mp3 (relative to this script) and plays it.
# Exits 0 silently if the file is missing or no player is available, so hooks never fail.

EVENT_NAME="$1"

if [ -z "$EVENT_NAME" ]; then
  echo "Usage: $0 <EventName>" >&2
  exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
SOUND_FILE="$SCRIPT_DIR/sounds/$EVENT_NAME.mp3"
[ -f "$SOUND_FILE" ] || exit 0

# Play in background so the hook returns immediately (matches winmm "play snd"
# semantics — fire-and-forget; the original "play snd wait" blocks, which we
# intentionally avoid here to keep hook latency low).
if command -v afplay >/dev/null 2>&1; then
  # macOS built-in
  afplay "$SOUND_FILE" >/dev/null 2>&1 &
elif command -v mpg123 >/dev/null 2>&1; then
  mpg123 -q "$SOUND_FILE" >/dev/null 2>&1 &
elif command -v ffplay >/dev/null 2>&1; then
  ffplay -nodisp -autoexit -loglevel quiet "$SOUND_FILE" >/dev/null 2>&1 &
elif command -v paplay >/dev/null 2>&1; then
  paplay "$SOUND_FILE" >/dev/null 2>&1 &
fi

exit 0
