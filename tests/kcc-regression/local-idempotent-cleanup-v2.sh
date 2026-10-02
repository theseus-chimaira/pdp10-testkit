#!/bin/sh
set -eu

testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMPROOT=${TMPDIR:-.}/kcc-local-idempotent-cleanup-v2-$$
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

compile_one tests/semantic/regression/struct-offset-bug.c zeroimm
compile_one tests/semantic/regression/byte-extract-6.c signext
compile_one tests/validation/gcc/abi/abi_call_torture_07.c selfmove
compile_one tests/codegen/pattern/subdi3.c dimode

# Final peephole cleanup must remove arithmetic/logical identities created by
# earlier folds in the same flush.
if grep -Eiq '^[[:space:]]*(addi|subi|iori|xori)[[:space:]]+[0-7]+,0([[:space:]]|$)' \
    "$TMPROOT/zeroimm/zeroimm.s"; then
    echo "zero-immediate identity survived final peephole cleanup" >&2
    exit 1
fi

# Exact-width signed loads are normalized once, not once in the load path and
# again during integer promotion.
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
' "$TMPROOT/signext/signext.s"

# A self DMOVE can expand to two MOVE R,R instructions on the base/PDP-6
# target.  Neither form may survive final output.
awk '
    BEGIN { bad = 0 }
    /^[ \t]*[Mm][Oo][Vv][Ee][ \t]/ {
        s = $0
        sub(/^[ \t]*[Mm][Oo][Vv][Ee][ \t]+/, "", s)
        split(s, a, /[ \t]*,[ \t]*/)
        if (a[1] ~ /^[0-7]+$/ && a[1] == a[2]) bad = 1
    }
    END { exit bad }
' "$TMPROOT/selfmove/selfmove.s" || {
    echo "self MOVE survived DMOVE lowering" >&2
    exit 1
}

# Internal signed DImode is already high36:low35 canonical.  Returning or
# storing it must not emit adjacent duplicate low-word canonicalization.
awk '
    function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); return s }
    {
        cur = trim($0)
        if (cur ~ /^[Tt][Ll][Zz][ \t]/ && cur == prev) {
            print "duplicate DImode TLZ survived: " cur > "/dev/stderr"
            exit 1
        }
        prev = cur
    }
' "$TMPROOT/dimode/dimode.s"

echo "local idempotent cleanup v2 regression passed"
