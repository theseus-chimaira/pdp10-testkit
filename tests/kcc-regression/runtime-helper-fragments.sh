#!/bin/sh
set -eu

testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
AS=$PDP10_PREFIX/bin/pdp10-dec-none-as
tmp=${TMPDIR:-/tmp}/kcc-runtime-helper-fragments-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

for machine in pdp6 ka10 ks10; do
    for helper in adjbp kdfad kdfsb kdfmp kdfdv; do
        src="$root/${machine}rt-${helper}.s"
        "$AS" -O "$tmp/${machine}-${helper}.o" "$src" >/dev/null
    done
done

"$AS" -O "$tmp/zero.o" "$root/kccrt-zero.s" >/dev/null
"$AS" -O "$tmp/dimode-div.o" "$root/kccrt-dimode-div.s" >/dev/null

echo "KCC split runtime helper fragments assemble independently"
