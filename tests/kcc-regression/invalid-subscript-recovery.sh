#!/bin/sh
# Invalid subscripting must diagnose and return normally.
set -eu

testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-invalid-subscript-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

cat > "$tmp/t.c" <<'SRC'
int bad_subscript(void)
{
    int value;

    return value[0];
}
SRC

cd "$tmp"
set +e
"$KCC" -S t.c >t.out 2>t.err
status=$?
set -e

if test "$status" -eq 0; then
    echo "invalid subscript unexpectedly accepted" >&2
    exit 1
fi
if test "$status" -gt 128; then
    echo "KCC terminated by signal while diagnosing invalid subscript" >&2
    cat t.err >&2
    exit 1
fi
if ! grep -q "Array or pointer type required" t.err; then
    echo "missing invalid-subscript diagnostic" >&2
    cat t.err >&2
    exit 1
fi

printf '%s\n' 'invalid subscript recovery passed'
