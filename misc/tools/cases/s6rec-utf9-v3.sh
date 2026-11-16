#!/bin/sh
set -eu
: "${PDP10_TOOLS_WORK:?shared tools build is required}"
cd "$PDP10_TOOLS_WORK"
exec python3 ./tests/test-s6rec-utf9-v1.py \
    "$PDP10_TOOLS_WORK/utf9-s6rec-v1" \
    "$PDP10_TOOLS_WORK/s6rec-utf9-v1" "$PDP10_TOOLS_WORK/utf9-file-v1"
