#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-push-address-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
: "${KCC:=$(pwd)/kcc}"
cat > "$TMP/test.c" <<'SRC'
typedef long long Dint;
Dint loadpair(Dint *p) { Dint x = *p; return x; }
SRC
(cd "$TMP" && "$KCC" -S -v=nostats -x=ki10 -R=test test.c)
if awk '
{
    if (tolower($1) == "setm") {
        split($2, a, ",")
        copied = a[1]
        source = a[2]
        getline l2
        getline l3
        x2 = tolower(l2)
        x3 = tolower(l3)
        if (x2 ~ ("push[[:space:]]+17,0\\(" copied "\\)") &&
            x3 ~ ("push[[:space:]]+17,1\\(" source "\\)"))
            exit 1
    }
}
' "$TMP/test.s"; then
    :
else
    echo 'copied DImode push address was not folded' >&2
    exit 1
fi
echo 'DImode push-address fold regression passed'
