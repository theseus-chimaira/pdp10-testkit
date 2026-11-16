#!/bin/sh
set -eu
: "${PDP10_TOOLS_WORK:?shared tools build is required}"
cd "$PDP10_TOOLS_WORK"
exec sh ./tests/pdp10-objdump-test.sh
