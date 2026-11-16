#!/bin/sh
set -eu
: "${PDP10_TOOLS_WORK:?shared tools build is required}"
cd "$PDP10_TOOLS_WORK"
exec python3 ./tests/media-encoders-test-v1.py \
    "$PDP10_TOOLS_WORK/mkdt" "$PDP10_TOOLS_WORK/mkstream" \
    "$PDP10_TOOLS_WORK/words2pt" "$PDP10_TOOLS_WORK/tests/media-fixtures-v2"
