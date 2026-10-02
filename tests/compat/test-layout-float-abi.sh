#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-layout-float-abi-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

"$PDP10_GCC" -S -O1 -fno-inline -mlong-long-71bit \
    -o "$tmp/gcc.s" "$root/tests/compat/layout-float-abi.c"
(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=base -R=p10lfv10 \
        "$root/tests/compat/layout-float-abi.c"
)

# Signed fields occupy one word and require sign extraction in both outputs.
for asm in "$tmp/gcc.s" "$tmp/p10lfv10.s"; do
    grep -A30 '^abi_signed_bits_v10:' "$asm" | \
        grep -Ei '(^|[[:space:]])(ash|ldb)[[:space:]]+' >/dev/null
    grep -A30 '^abi_cross_bits_v10:' "$asm" | \
        grep -Ei '(^|[[:space:]])ldb[[:space:]]+' >/dev/null
    grep -A12 '^abi_float_return_v10:' "$asm" | \
        grep -Ei '(^|[[:space:]])fadr[[:space:]]+' >/dev/null
    grep -A40 '^abi_double_return_v10:' "$asm" | \
        grep -Ei '(^|[[:space:]])(dfad|pushj[[:space:]]+17,(\$KDFAD|__adddf3))' >/dev/null
    grep -A15 '^abi_float_call_v10:' "$asm" | \
        grep -Ei 'pushj[[:space:]]+17,.*\([0-9]+\)' >/dev/null
    grep -A20 '^abi_double_call_v10:' "$asm" | \
        grep -Ei 'pushj[[:space:]]+17,.*\([0-9]+\)' >/dev/null
done

# Both use one word for the signed in-word field sequence.
for asm in "$tmp/gcc.s" "$tmp/p10lfv10.s"; do
    grep -A5 '^abi_signed_layout_words_v10:' "$asm" | \
        grep -Ei 'movei?[[:space:]]+1,1([^0-7]|$)' >/dev/null
done

# Cross-word packing agrees: both compilers use two words.
grep -A5 '^abi_cross_layout_words_v10:' "$tmp/gcc.s" | \
    grep -Ei 'movei?[[:space:]]+1,2([^0-7]|$)' >/dev/null
grep -A5 '^abi_cross_layout_words_v10:' "$tmp/p10lfv10.s" | \
    grep -Ei 'movei?[[:space:]]+1,2([^0-7]|$)' >/dev/null

echo "KCC/GCC signed/cross-word fields and floating ABI agree"
