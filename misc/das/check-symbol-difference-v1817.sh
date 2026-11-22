#!/bin/sh
# Original v1453 artifact preserved in misc/das/symbol-difference-v1817;
# current-source DAS must reject independent relocation base cancellation.
set -eu
: "${PDP10_PREFIX:?PDP10_PREFIX must identify the installed tools}"
TMPDIR=${TMPDIR:-$HOME/tmp}
das=${DAS_V1817:-${DAS_ROOT:?DAS_ROOT must identify DAS source}/das}
here=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)
fixtures="$here/symbol-difference-v1817"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/das-symbol-difference-v1817.XXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

for name in cross-object-v1453 different-section-v1817 \
    different-extern-v1817 reversed-extern-v1817; do
    if "$das" -F -C -O "$work/$name.dobj" "$fixtures/$name.s" \
        >"$work/$name.log" 2>&1; then
        echo "FAIL v1817: independent relocation accepted: $name" >&2
        exit 1
    fi
    grep -q 'unsupported difference of separately relocated symbols' \
        "$work/$name.log" || {
        echo "FAIL v1817: wrong assembler rejection for $name" >&2
        cat "$work/$name.log" >&2
        exit 1
    }
    echo "PASS v1817: independent relocation rejected ($name)"
done

"$das" -F -C -O "$work/same-object-v1453.dobj" \
    "$fixtures/same-object-v1453.s"
"$PDP10_PREFIX/bin/pdp10-objdump" -d \
    "$work/same-object-v1453.dobj" > "$work/same-object.dump"
grep -q '^000000:.*000061' "$work/same-object.dump"
echo 'PASS v1817: same-section label difference encoded as 000061'

"$das" -F -C -O "$work/same-extern-v1817.dobj" \
    "$fixtures/same-extern-v1817.s"
"$PDP10_PREFIX/bin/pdp10-objdump" \
    "$work/same-extern-v1817.dobj" >"$work/same-extern.dump"
grep -q 'relocs=1' "$work/same-extern.dump" || {
    echo 'FAIL v1817: unexpected relocation count for same-base cancellation' >&2
    head -5 "$work/same-extern.dump" >&2
    exit 1
}
echo 'PASS v1817: one external base cancels in all expression orders'

echo 'PASS v1817: host DAS symbol relocation identity tests'
