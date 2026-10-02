#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-indexed-store-forward-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
extern int source(void);
extern int sink(int);

int forward(int *p)
{
    *p = source();
    return sink(*p);
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

# The call result is stored through p, then forwarded from the still-live AC.
grep -Eq 'movem[[:space:]]+1,0\([0-7]+\)[[:space:]]*$' "$ASM"
if grep -Eq 'move[[:space:]]+3,0\(10\)[[:space:]]*$' "$ASM"; then
    echo "register-indexed store was reloaded from memory" >&2
    exit 1
fi
grep -Eq 'jrst[[:space:]]+sink[[:space:]]*$' "$ASM"

echo "register-indexed store forwarding regression passed"
