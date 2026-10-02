#!/bin/sh
set -eu

TEST_ROOT=${TEST_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)}
DAS_ROOT=${DAS_ROOT:?set DAS_ROOT to the DAS source tree}
TMPDIR=${TMPDIR:?set TMPDIR to a writable temporary directory}
BASE=$TMPDIR/das-phase2-transport-v1-$$
trap 'rm -f "$BASE".*' 0 1 2 3 15

FILE_DXR=$BASE.file.dxr
PIPE_DXR=$BASE.pipe.dxr
FILE_LABELS=$BASE.file.labels
PIPE_LABELS=$BASE.pipe.labels

"$DAS_ROOT/das" -A -F -L "$FILE_LABELS" -O "$FILE_DXR" \
    "$TEST_ROOT/dxr-macro-opt-label-v1.s"
if [ -e "$FILE_DXR.D2R" ]; then
    echo "DAS left private phase file after successful file-mode assembly" >&2
    exit 1
fi
"$DAS_ROOT/das" -A -F -P -L "$PIPE_LABELS" -O "$PIPE_DXR" \
    "$TEST_ROOT/dxr-macro-opt-label-v1.s"
cmp "$FILE_DXR" "$PIPE_DXR"
cmp "$FILE_LABELS" "$PIPE_LABELS"

"$DAS_ROOT/das" -A -F -O "$BASE.file-ea.dxr" \
    "$TEST_ROOT/dxr-optimize-ea-audit-v1.s"
"$DAS_ROOT/das" -A -F -P -O "$BASE.pipe-ea.dxr" \
    "$TEST_ROOT/dxr-optimize-ea-audit-v1.s"
cmp "$BASE.file-ea.dxr" "$BASE.pipe-ea.dxr"

if : | "$DAS_ROOT/das2" -P -O "$BASE.bad.dxr" >/dev/null 2>&1; then
    echo "das2 accepted an empty private phase stream" >&2
    exit 1
fi

printf '%s\n' "DAS file/pipe phase transport contract passed"
