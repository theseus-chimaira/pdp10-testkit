#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-wide-int-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/probe.c" <<'SRC'
#include "insns.h"
int71_t a71;
uint71_t u71;
int72_t a72;
uint72_t u72;
int probe(void) { return sizeof(a71) == 2 && sizeof(a72) == 2; }
SRC
"$PDP10_GCC" -S -O1 -mlong-long-71bit -I"$root/support/common" -I"$root/support/gcc" -o "$tmp/g71.s" "$tmp/probe.c"
"$PDP10_GCC" -S -O1 -mlong-long-72bit -I"$root/support/common" -I"$root/support/gcc" -o "$tmp/g72.s" "$tmp/probe.c"
(
    cd "$tmp"
    "$KCC" -S -v=nostats -x=base \
        -I"$root/support/common/" -I"$root/support/kcc/" \
        -R=p10wimv7 "$tmp/probe.c"
)
"$PDP10_GCC" -S -O1 -mlong-long-71bit -I"$root/support/common" -o "$tmp/raw72.s" "$root/support/common/raw72.c"
test -s "$tmp/g71.s"
test -s "$tmp/g72.s"
test -s "$tmp/p10wimv7.s"
test -s "$tmp/raw72.s"
for sym in raw72_mul raw72_udivmod raw72_sdivmod raw72_from_int71_words raw72_to_int71_words; do
	grep "$sym" "$tmp/raw72.s" >/dev/null
done
echo "71-bit native and raw 72-bit adapter modes compile"
