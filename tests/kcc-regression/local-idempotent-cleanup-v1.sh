#!/bin/sh
set -eu

testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMPROOT=${TMPDIR:-.}/kcc-local-idempotent-cleanup-v1-$$
trap 'rm -rf "$TMPROOT"' EXIT HUP INT TERM
mkdir -p "$TMPROOT"

compile_one()
{
    src=$1
    stem=$2
    d=$TMPROOT/$stem
    mkdir -p "$d"
    cp "$testroot/../../$src" "$d/test.c"
    (
        cd "$d"
        "$KCC" -S -v=nostats -x=base \
            -I"$testroot/../../support/kcc/" \
            -I"$testroot/../../support/common/" \
            -I"$testroot/../../support/include/" \
            -R="$stem" test.c >/dev/null
    )
}

compile_one tests/semantic/regression/global-data.c global-data
compile_one tests/semantic/runtime/runtime-qimem-corners.c qimem
compile_one tests/semantic/regression/decrement-pointer.c decptr

# No immediately repeated identical TLZ may survive in global-data.c.
awk '
    function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); return s }
    {
        cur = trim($0)
        if (cur ~ /^([Tt][Ll][Zz])[ \t]/ && cur == prev) {
            print "duplicate TLZ survived: " cur > "/dev/stderr"
            exit 1
        }
        prev = cur
    }
' "$TMPROOT/global-data/global-data.s"

# The QI corner test used to contain exact duplicate signed-extension triples.
awk '
    function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); return s }
    {
        line[NR % 6] = trim($0)
        if (NR >= 6) {
            a1 = line[(NR-5) % 6]; a2 = line[(NR-4) % 6]; a3 = line[(NR-3) % 6]
            b1 = line[(NR-2) % 6]; b2 = line[(NR-1) % 6]; b3 = line[NR % 6]
            if (a1 == b1 && a2 == b2 && a3 == b3 &&
                a1 ~ /^([Tt][Rr][Nn][Ee]|[Tt][Ll][Nn][Ee])[ \t]/ &&
                a2 ~ /^[Tt][Dd][Oo][Aa][ \t]/ &&
                a3 ~ /^[Aa][Nn][Dd][Ii][ \t]/) {
                print "duplicate signed extension survived" > "/dev/stderr"
                exit 1
            }
        }
    }
' "$TMPROOT/qimem/qimem.s"

# Late register retargeting must not leave MOVE R,R behind in this case.
if grep -Eiq '^[[:space:]]*move[[:space:]]+([0-7]+),\1([[:space:]]|$)' \
    "$TMPROOT/decptr/decptr.s"; then
    echo "self MOVE survived late peephole cleanup" >&2
    exit 1
fi

echo "local idempotent cleanup regression passed"
