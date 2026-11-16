#!/bin/sh
set -eu
: "${PDP10_TOOLS_WORK:?shared tools build is required}"
cd "$PDP10_TOOLS_WORK"
export CSIX="$PDP10_TOOLS_WORK/csix"
exec sh ./tests/csix-test.sh
