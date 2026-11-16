#!/bin/sh
set -eu
: "${PDP10_TOOLS_WORK:?shared tools build is required}"
cd "$PDP10_TOOLS_WORK"
exec sh ./tests/p10run-functional-test.sh
