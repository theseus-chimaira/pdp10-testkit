#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env

tmpbase=${TMPDIR:-/tmp}
test -d "$tmpbase" && test -w "$tmpbase" || tmpbase=.
tmp=$(mktemp -d "$tmpbase/kcc-dimode-exhaustion.XXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
cat > "$tmp/test.c" <<'SRC'
typedef long long D;
typedef unsigned long long U;
D f(D a, D b, D c, D d) { return ((a + b) ^ (c - d)) + (a ? c : d); }
U g(U a, U b, U c) { return ((a | b) & ~c) + (b ? a : c); }
int h(D a, D b, U c, U d) { return a < b || c >= d; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    rm -f "$tmp/test.s"
    (cd "$tmp" && "$KCC" -x="$cpu" -S -v=nostats test.c >/dev/null)
    test -s "$tmp/test.s"
done
echo 'DImode exhaustion compile regression passed'
