#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-signed-power2-div-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat >"$TMP/test.c" <<'SRC'
int div1(int x) { return x / 1; }
int mod1(int x) { return x % 1; }
int div2(int x) { return x / 2; }
int div8(int x) { return x / 8; }
int mod8(int x) { return x % 8; }
int div3(int x) { return x / 3; }
SRC

(
    cd "$TMP"
    "$KCC" -S -x=pdp6 test.c >/dev/null
)
ASM=$TMP/test.s

block()
{
    awk -v name="$1" '
        $0 == name ":" { found = 1; next }
        found && /^[A-Za-z_][A-Za-z0-9_]*:/ { exit }
        found { print }
    ' "$ASM"
}

for fn in div1 mod1 div2 div8 mod8; do
    if block "$fn" | grep -Eiq '(^|[[:space:]])IDIV([[:space:]]|$)|%SIDN|%UIDN'; then
        echo "$fn still used the signed divide helper" >&2
        exit 1
    fi
done

block div2 | grep -Eiq 'ash[[:space:]]+[0-7]+,-1' || {
    echo "div2 did not use arithmetic shift" >&2
    exit 1
}
block div8 | grep -Eiq 'ash[[:space:]]+[0-7]+,-3' || {
    echo "div8 did not use arithmetic shift" >&2
    exit 1
}
block mod8 | grep -Eiq 'sub[[:space:]]+[0-7]+,0?16' || {
    echo "mod8 did not derive the signed remainder locally" >&2
    exit 1
}

if ! block div3 | grep -Eiq '(^|[[:space:]])IDIV([[:space:]]|$)|%SIDN'; then
    echo "non-power-of-two signed divide unexpectedly bypassed helper" >&2
    exit 1
fi

echo "signed power-of-two divide regression passed"
