#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-int71-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

cat > "$tmp/probe.c" <<'SRC'
#include "insns.h"

Dint sd;
uDint ud;
int71_t si;
uint71_t ui;

int
probe(void)
{
	return sizeof(sd) == 2 * sizeof(int) &&
	    sizeof(ud) == 2 * sizeof(int) &&
	    sizeof(si) == 2 * sizeof(int) &&
	    sizeof(ui) == 2 * sizeof(int);
}
SRC

"$PDP10_GCC" -S -O1 -mlong-long-71bit -I"$root/support/common" -I"$root/support/gcc" \
    -o "$tmp/gcc.s" "$tmp/probe.c"
(
    cd "$tmp"
    "$KCC" -S -v=nostats -x=base \
        -I"$root/support/common/" -I"$root/support/kcc/" \
        -R=p10i71v7 "$tmp/probe.c"
)

test -s "$tmp/gcc.s"
test -s "$tmp/p10i71v7.s"

grep -A2 '^probe:' "$tmp/gcc.s" | grep -Ei 'movei[[:space:]]+1,1([[:space:]]|$)' >/dev/null
grep -A2 '^probe:' "$tmp/p10i71v7.s" | grep -Ei 'movei[[:space:]]+1,1([[:space:]]|$)' >/dev/null

echo "int71 compatibility headers compile as two-word types"
