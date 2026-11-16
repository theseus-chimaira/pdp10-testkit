#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-$HOME/tmp}/kcc-terminal-return-chain-$$
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
    "$KCC" -x=pdp6 -S test.c >/dev/null
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

# AC1 holds the first argument. A direct ADD 1,2 preserves that input and
# avoids an unnecessary temporary; older legal code may still copy back.
grep -A8 '^add_other:' "$ASM" | grep -Eq \
    'add[[:space:]]+1,2|move[[:space:]]+1,[2-7]'

cat > "$TMP/run.c" <<'SRC'
struct packed_word { unsigned long w; };
extern int uid(struct packed_word *);
extern int cono(int);
extern int addbase(int);
extern int add_other(int, int);
int pia = 012;
int base = 014;
volatile int __test_exit;
int main(void)
{
    struct packed_word p;

    p.w = 0777UL << 18;
    if (uid(&p) != 0777)
        return 1;
    if (cono(05) != (05 | 012))
        return 2;
    if (addbase(03) != 017)
        return 3;
    if (add_other(07, 011) != 020)
        return 4;
    return 0;
}
SRC
"$KCC" -x=pdp6 -S -o "$TMP/run.s" "$TMP/run.c" >/dev/null
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 25 \
    --workdir "$TMP/execution" --name terminal-return-chain-v2 \
    --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$ASM" "$TMP/run.s" >/dev/null

echo "terminal return chain regression passed"
