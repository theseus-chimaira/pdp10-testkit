#!/bin/sh
set -eu
: "${PDP10_TOOLS_WORK:?shared tools build is required}"
cd "$PDP10_TOOLS_WORK"
export P10FOLD_LINK_MK="$PDP10_TOOLS_WORK/tests/p10fold-link-mk"
export P10FOLD="$PDP10_TOOLS_WORK/p10fold"
export DLINK="$PDP10_TOOLS_WORK/dlink"
exec sh ./tests/p10fold-link-test.sh
