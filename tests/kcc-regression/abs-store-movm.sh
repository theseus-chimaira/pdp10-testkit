#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-abs-store-movm-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
int a, b;
volatile int va;

void mm()
{
    b = a < 0 ? -a : a;
}

int ms_used()
{
    return (a = a < 0 ? -a : a);
}

void ms_discard()
{
    a = a < 0 ? -a : a;
}

void no_mm_used()
{
    a = (b = a < 0 ? -a : a);
}

void no_volatile()
{
    b = va < 0 ? -va : va;
}

int ptr_load(p)
int *p;
{
    return *p < 0 ? -*p : *p;
}

void ptr_mm(a, p)
int a;
int *p;
{
    *p = a < 0 ? -a : a;
}

int ptr_ms(p)
int *p;
{
    return (*p = *p < 0 ? -*p : *p);
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

body()
{
    awk -v fn="$1" '$0 == fn ":" {p=1; next} /^[A-Za-z_][A-Za-z0-9_]*:/ {if(p) exit} p' "$ASM"
}

mmbody=$(body mm)
printf '%s\n' "$mmbody" | grep -Eq '^[[:space:]]*movmm[[:space:]]'
if printf '%s\n' "$mmbody" | grep -Eq '^[[:space:]]*movm[[:space:]]'; then
    echo "discarded abs store retained MOVM instead of MOVMM" >&2
    exit 1
fi

for fn in ms_used ms_discard; do
    x=$(body "$fn")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*movms[[:space:]]'
    if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*movem[[:space:]]'; then
        echo "$fn retained separate MOVEM after MOVMS" >&2
        exit 1
    fi
done

x=$(body no_mm_used)
if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*movmm[[:space:]]'; then
    echo "MOVMM used where the assignment value remains live" >&2
    exit 1
fi

x=$(body no_volatile)
if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*movm[m|s]?[[:space:]]'; then
    echo "volatile absolute-value store was incorrectly folded" >&2
    exit 1
fi

x=$(body ptr_load)
printf '%s\n' "$x" | grep -Eq '^[[:space:]]*movm[[:space:]]+1,'
if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*(skipl|jump|jrst)[[:space:]]'; then
    echo "pointer absolute-value load retained conditional control flow" >&2
    exit 1
fi

x=$(body ptr_mm)
printf '%s\n' "$x" | grep -Eq '^[[:space:]]*movmm[[:space:]]+1,'
if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*move[[:space:]].*,1$'; then
    echo "pointer MOVMM retained an unnecessary source-register copy" >&2
    exit 1
fi

x=$(body ptr_ms)
printf '%s\n' "$x" | grep -Eq '^[[:space:]]*movms[[:space:]]'
if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*movem[[:space:]]'; then
    echo "pointer MOVMS retained separate MOVEM" >&2
    exit 1
fi

echo "absolute-value MOVMM/MOVMS regression passed"
