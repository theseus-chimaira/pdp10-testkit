#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-hrlz-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

cat > "$tmp/t.c" <<'SRC'
unsigned long f(unsigned long x)
{
    return (x & 0777777UL) << 18;
}

unsigned long g(unsigned long *p)
{
    return (*p & 0777777UL) << 18;
}
SRC

(
    cd "$tmp"
    "$KCC" -S t.c >/dev/null
)

grep -qi 'hrlz' "$tmp/t.s"
if grep -Ei '^[[:space:]]*lsh[[:space:]].*,22' "$tmp/t.s" >/dev/null 2>&1; then
    echo "late HRLZ fold left an LSH by 18" >&2
    cat "$tmp/t.s" >&2
    exit 1
fi

echo "late HRLZ fold regression passed"
