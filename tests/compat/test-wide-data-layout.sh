#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-wide-layout-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

"$PDP10_GCC" -S -O1 -mlong-long-71bit \
    -I"$root/support/common" -I"$root/support/gcc" \
    -o "$tmp/gcc.s" "$root/tests/compat/wide-data-layout.c"
(
    cd "$tmp"
    "$KCC" -S -v=nostats -x=base \
        -I"$root/support/common/" -I"$root/support/kcc/" \
        -R=p10wdlv7 "$root/tests/compat/wide-data-layout.c"
)

for asm in "$tmp/gcc.s" "$tmp/p10wdlv7.s"; do
    grep -A2 '^layout_word:' "$asm" | grep -Ei 'movei[[:space:]]+1,4([[:space:]]|$)' >/dev/null
    grep -A2 '^layout_int71:' "$asm" | grep -Ei 'movei[[:space:]]+1,010([[:space:]]|$)' >/dev/null
    grep -A2 '^layout_raw72:' "$asm" | grep -Ei 'movei[[:space:]]+1,010([[:space:]]|$)' >/dev/null
    grep -A2 '^layout_wide_pair:' "$asm" | grep -Ei 'movei[[:space:]]+1,020([[:space:]]|$)' >/dev/null
    grep -A2 '^layout_mixed_wide:' "$asm" | grep -Ei 'movei[[:space:]]+1,020([[:space:]]|$)' >/dev/null
    grep -A2 '^layout_raw_pair:' "$asm" | grep -Ei 'movei[[:space:]]+1,020([[:space:]]|$)' >/dev/null
done

echo "KCC/GCC wide integer data layout agrees"
