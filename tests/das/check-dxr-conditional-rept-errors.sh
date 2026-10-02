#!/bin/sh
set -eu
TEST_ROOT=$1
DAS=$2
TMPDIR=${TMPDIR:?set TMPDIR to a writable temporary directory}
TMP=$TMPDIR/das-cond-rept-errors.$$
trap 'rm -f "$TMP".*' 0 1 2 3 15

bad()
{
    name=$1
    shift
    printf '%s\n' "$@" > "$TMP.$name.s"
    if "$DAS" -A -O "$TMP.$name.dxr" "$TMP.$name.s" >/dev/null 2>&1; then
        echo "DAS accepted invalid conditional/repetition case: $name" >&2
        exit 1
    fi
}

bad ifdef-empty '.ifdef' '.endif'
bad ifndef-name '.ifndef 1BAD' '.endif'
bad unmatched-endr '.endr'
bad unterminated-rept '.rept 1' '.word 1'
bad reloc-rept '.rept TARGET' 'TARGET: .word 1' '.endr'
bad huge-rept '.rept 0200000' '.word 1' '.endr'

: > "$TMP.deep.s"
i=0
while [ "$i" -lt 9 ]; do
    echo '.rept 1' >> "$TMP.deep.s"
    i=$((i + 1))
done
echo '.word 1' >> "$TMP.deep.s"
i=0
while [ "$i" -lt 9 ]; do
    echo '.endr' >> "$TMP.deep.s"
    i=$((i + 1))
done
if "$DAS" -A -O "$TMP.deep.dxr" "$TMP.deep.s" >/dev/null 2>&1; then
    echo 'DAS accepted repetition nesting deeper than 8' >&2
    exit 1
fi

printf '.rept 1\n.if 1\n.word 1\n.endr\n.endif\n' > "$TMP.cross.s"
if "$DAS" -A -O "$TMP.cross.dxr" "$TMP.cross.s" >/dev/null 2>&1; then
    echo 'DAS accepted conditional crossing a repetition boundary' >&2
    exit 1
fi

echo 'DAS conditional/repetition diagnostics contract passed'
