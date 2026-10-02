#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-memory-result-fold-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
unsigned long a, b, c, d;

void f_add(x)
unsigned long x;
{
    a += x;
}

void f_and(x)
unsigned long x;
{
    b &= x;
}

void f_or(x)
unsigned long x;
{
    c |= x;
}

void f_xor(x)
unsigned long x;
{
    d ^= x;
}

void f_cand()
{
    b &= 7;
}

void f_cor()
{
    c |= 010;
}

void f_cxor()
{
    d ^= 077;
}

void f_complex(x)
unsigned long x;
{
    a += x + 1;
}

extern unsigned long ext(void);

unsigned long f_reg_call(x)
unsigned long x;
{
    x += ext();
    return x;
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

for op in addb andb iorb xorb; do
    if ! grep -Eq "^[[:space:]]*$op[[:space:]]+[0-9]+," "$ASM"; then
        echo "missing $op memory-result fold" >&2
        exit 1
    fi
done

for spec in 'andb.*b' 'iorb.*c' 'xorb.*d'; do
    if ! grep -Eq "^[[:space:]]*${spec}" "$ASM"; then
        echo "missing constant memory-result fold: $spec" >&2
        exit 1
    fi
done

if grep -A8 '^f_complex:' "$ASM" | grep -Eq '^[[:space:]]*addb[[:space:]]'; then
    echo "non-leaf memory compound RHS incorrectly used direct memory-result fold" >&2
    exit 1
fi

regcall=$(awk '/^f_reg_call:/{p=1;next}/^[A-Za-z_][A-Za-z0-9_]*:/{if(p)exit}p' "$ASM")
if ! printf '%s\n' "$regcall" | grep -Eq '^[[:space:]]*addb[[:space:]]+[0-9]+,0?10([[:space:]]|$)'; then
    echo "register compound assignment did not use accumulator-address ADDB" >&2
    exit 1
fi
if printf '%s\n' "$regcall" | grep -Eq '^[[:space:]]*addb[[:space:]]+[0-9]+,0\(0?10\)'; then
    echo "register compound assignment used indexed memory instead of AC10" >&2
    exit 1
fi

if grep -Eq '^[[:space:]]*movem[[:space:]]+[0-9]+,(b|c|d)([^A-Za-z0-9_]|$)' "$ASM"; then
    echo "compound assignment still emitted MOVEM" >&2
    exit 1
fi

echo "memory-result fold regression passed"
