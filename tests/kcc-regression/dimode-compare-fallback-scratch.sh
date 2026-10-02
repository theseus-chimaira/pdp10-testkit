#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
for cpu in pdp6 ka10 ki10 ks10; do
    TMPBASE=${TMPDIR:-/tmp}
    test -d "$TMPBASE" && test -w "$TMPBASE" || TMPBASE=.git
    TMP="$TMPBASE/kcc-dimode-compare-fallback-$$-$cpu"
    trap 'rm -rf "$TMP"' EXIT HUP INT TERM
    mkdir -p "$TMP"
    cat > "$TMP/test.c" <<'SRCFILE'
typedef long long D;
typedef unsigned long long U;
int scmp(D a, D b) { return a < b; }
int ucmp(U a, U b) { return a <= b; }
SRCFILE
    (cd "$TMP" && "$PDP10_PREFIX/bin/kcc" -x="$cpu" -S test.c >/dev/null)
    grep -Eq '^[[:space:]]*CAML?[[:space:]]' "$TMP/test.s"
    rm -rf "$TMP"
    trap - EXIT HUP INT TERM
done
echo 'DImode comparison fallback scratch regression passed'
