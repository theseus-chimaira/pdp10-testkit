#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env

tmpbase=${TMPDIR:-/tmp}
test -d "$tmpbase" && test -w "$tmpbase" || tmpbase=.
tmp=$(mktemp -d "$tmpbase/kcc-dimode-vrallspill.XXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
cat > "$tmp/test.c" <<'SRC'
typedef long long D;
typedef unsigned long long U;
D addsub(D a, D b, D c) { return a + b - c; }
D divide(D a, D b) { return b ? a / b : a; }
U bits(U a, U b, U c) { return (a & b) ^ ~c; }
D tern(D a, D b, int c) { return c ? a : b; }
int logic(D a, D b) { return a && b; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    rm -f "$tmp/test.s"
    (cd "$tmp" && "$KCC" -x="$cpu" -S -v=nostats test.c >/dev/null)
    test -s "$tmp/test.s"
done
echo 'DImode spill-pressure compile regression passed'
