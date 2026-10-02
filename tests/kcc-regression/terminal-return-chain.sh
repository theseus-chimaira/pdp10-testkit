#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-terminal-return-chain-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
struct packed_word { unsigned long w; };
extern int pia;
extern int base;

int uid(struct packed_word *p)
{
    return (int)((p->w >> 18) & 0777UL);
}

int cono(int x)
{
    return x | pia;
}

int addbase(int x)
{
    return x + base;
}

int add_other(int x, int y)
{
    return x + y;
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

grep -Eq 'hlrz[[:space:]]+1,0\(1\)' "$ASM"
grep -Eq 'andi[[:space:]]+1,0?777' "$ASM"
grep -Eq 'ior[[:space:]]+1,pia' "$ASM"
grep -Eq 'add[[:space:]]+1,base' "$ASM"

for fn in uid cono addbase; do
    if awk -v fn="$fn" '
$0 ~ ("^" fn ":") {f=1; next}
f && /popj[[:space:]]+17,/ {exit}
f && /move[[:space:]]+1,[2-7]/ {bad=1}
END {exit bad ? 0 : 1}
' "$ASM"; then
        echo "$fn retained terminal temporary copy" >&2
        exit 1
    fi
done

# The modifier reads the original AC1 value here, so the conservative guard
# must keep the temporary rather than retarget the chain into AC1.
grep -A8 '^add_other:' "$ASM" | grep -Eq 'move[[:space:]]+1,[2-7]'

echo "terminal return chain regression passed"
