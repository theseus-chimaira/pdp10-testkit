#!/bin/sh
set -eu
: "${PDP10_TOOLS_WORK:?shared tools build is required}"
here=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
export PDP10_TOOLS_REPO="$PDP10_TOOLS_WORK/source"
exec sh "$here/install-cleanup-test.sh"
