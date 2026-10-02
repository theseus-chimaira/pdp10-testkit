#!/bin/sh
set -eu

DAS_ROOT=${DAS_ROOT:?set DAS_ROOT to DAS source tree}
PDP10_PREFIX=${PDP10_PREFIX:?set PDP10_PREFIX}
TMPDIR=${TMPDIR:?set TMPDIR to writable temporary directory}
WORK=$(mktemp -d "$TMPDIR/das-symbol-leading-data-v1.XXXXXX")
trap 'rm -rf "$WORK"' EXIT HUP INT TERM

src=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)/dxr-symbol-leading-data-v1.s
bad=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)/dxr-bad-symbol-leading-op-v1.s

"$DAS_ROOT/das" -C -O "$WORK/t.dobj" "$src"
"$PDP10_PREFIX/bin/dlink" -b 030000 -o "$WORK/t.dxr" "$WORK/t.dobj"
word=$(
    "$DAS_ROOT/dxrcheck" -d "$WORK/t.dxr" |
    awk '$1 == "IMAGE" && $2 == "000001" { print $3 }'
)
case "$word" in
    762200030003) ;;
    *)
        echo "DAS symbol-leading relocatable data word mismatch: $word" >&2
        exit 1
        ;;
esac

if "$DAS_ROOT/das" -C -O "$WORK/bad.dobj" "$bad" >"$WORK/bad.out" 2>"$WORK/bad.err"; then
    echo "DAS accepted misspelled opcode as data expression" >&2
    exit 1
fi
if ! grep -qi 'unknown op moove' "$WORK/bad.err"; then
    echo "DAS misspelled-opcode diagnostic changed unexpectedly" >&2
    cat "$WORK/bad.err" >&2
    exit 1
fi

printf '%s\n' 'DAS symbol-leading relocatable data contract: PASS'
