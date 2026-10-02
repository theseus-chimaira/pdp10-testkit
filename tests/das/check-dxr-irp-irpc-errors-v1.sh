#!/bin/sh
set -eu

TEST_ROOT=${TEST_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)}
DAS=${1:-${DAS_ROOT:?set DAS_ROOT or pass DAS path}/das}
TMPDIR=${TMPDIR:?set TMPDIR to a writable temporary directory}
BASE=$TMPDIR/das-irp-errors-v1-$$
trap 'rm -f "$BASE".*' 0 1 2 3 15

bad()
{
    name=$1
    shift
    printf '%s\n' "$@" > "$BASE.$name.s"
    if "$DAS" -A -O "$BASE.$name.dxr" "$BASE.$name.s" >/dev/null 2>&1; then
        echo "DAS accepted malformed iterator case: $name" >&2
        exit 1
    fi
}

bad no-irp-symbol '.irp ,1,2' '.word 1' '.endr'
bad no-irpc-symbol '.irpc ,12' '.word 1' '.endr'
bad irp-no-comma '.irp X 1,2' '.word 1' '.endr'
bad irpc-no-comma '.irpc X 12' '.word 1' '.endr'
bad irp-label 'BAD: .irp X,1' '.word 1' '.endr'
bad irpc-quote '.irpc X,"12' '.word \X' '.endr'
bad irp-bracket '.irp X,(1,2' '.word \X' '.endr'
bad unterminated '.irp X,1,2' '.word \X'

: > "$BASE.deep.s"
i=0
while [ "$i" -lt 9 ]; do
    printf '.irp X%s,1\n' "$i" >> "$BASE.deep.s"
    i=$((i + 1))
done
printf '.word 1\n' >> "$BASE.deep.s"
i=0
while [ "$i" -lt 9 ]; do
    printf '.endr\n' >> "$BASE.deep.s"
    i=$((i + 1))
done
if "$DAS" -A -O "$BASE.deep.dxr" "$BASE.deep.s" >/dev/null 2>&1; then
    echo 'DAS accepted iterator nesting deeper than eight levels' >&2
    exit 1
fi

echo 'DAS .irp/.irpc malformed-input contract passed'
