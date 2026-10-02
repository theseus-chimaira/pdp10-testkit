#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-halfword-store-fold-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat >"$TMP/test.c" <<'SRC'
void setr(unsigned long *p, unsigned long x)
{
    *p = (*p & 0777777000000UL) | (x & 0777777UL);
}

void setl(unsigned long *p, unsigned long x)
{
    *p = (*p & 0777777UL) | ((x & 0777777UL) << 18);
}

void setrmem(unsigned long *p, const unsigned long *q)
{
    *p = (*p & 0777777000000UL) | (*q & 0777777UL);
}

void setlmem(unsigned long *p, const unsigned long *q)
{
    *p = (*p & 0777777UL) | (((*q >> 18) & 0777777UL) << 18);
}

void setlraw(unsigned long *p, unsigned long x)
{
    *p = (*p & 0777777UL) | (x << 18);
}
SRC

(
    cd "$TMP"
    "$KCC" -S test.c >/dev/null
)

ASM=$TMP/test.s

function_body()
{
    name=$1
    awk -v name="$name" '
        $0 == name ":" { in_fn = 1; next }
        in_fn && /^[A-Za-z_][A-Za-z0-9_]*:$/ { exit }
        in_fn { print }
    ' "$ASM"
}

setr_body=$(function_body setr)
setl_body=$(function_body setl)
setrmem_body=$(function_body setrmem)
setlmem_body=$(function_body setlmem)
setlraw_body=$(function_body setlraw)

printf '%s\n' "$setr_body" | grep -Eq 'hrrm[[:space:]]+[0-7]+,0\(1\)'
printf '%s\n' "$setl_body" | grep -Eq 'hrlm[[:space:]]+[0-7]+,0\(1\)'
printf '%s\n' "$setrmem_body" | grep -Eq 'hrrz[[:space:]]+[0-7]+,0\(2\)'
printf '%s\n' "$setrmem_body" | grep -Eq 'hrrm[[:space:]]+[0-7]+,0\(1\)'
printf '%s\n' "$setlmem_body" | grep -Eq 'hlrz[[:space:]]+[0-7]+,0\(2\)'
printf '%s\n' "$setlmem_body" | grep -Eq 'hrlm[[:space:]]+[0-7]+,0\(1\)'
printf '%s\n' "$setlraw_body" | grep -Eq 'hrlm[[:space:]]+[0-7]+,0\(1\)'
if printf '%s\n%s\n' "$setlmem_body" "$setlraw_body" | grep -Eq 'lsh[[:space:]]'; then
    echo "left-half store fold retained LSH" >&2
    exit 1
fi

if printf '%s\n%s\n%s\n%s\n%s\n' "$setr_body" "$setl_body" "$setrmem_body" "$setlmem_body" "$setlraw_body" |
   grep -Eq 'movem[[:space:]]+[0-7]+,0\(1\)'; then
    echo "halfword store fold retained full-word MOVEM" >&2
    exit 1
fi

echo "halfword store fold regression passed"
