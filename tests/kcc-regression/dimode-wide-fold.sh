#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
TMPBASE=${TMPDIR:-/tmp}
TMP=$TMPBASE/kcc-dimode-wide-fold-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
typedef long long S;
typedef unsigned long long U;
U l34(void) { return 1ULL << 34; }
U l35(void) { return 1ULL << 35; }
U l36(void) { return 1ULL << 36; }
U l70(void) { return 1ULL << 70; }
U r35(void) { return 0x400000000000000000ULL >> 35; }
U r36(void) { return 0x400000000000000000ULL >> 36; }
U r70(void) { return 0x400000000000000000ULL >> 70; }
S ar35(void) { return ((S)0x400000000000000000ULL) >> 35; }
S ar70(void) { return ((S)0x400000000000000000ULL) >> 70; }
U carry(void) { return 0x7ffffffffULL + 1ULL; }
U borrow(void) { return 0x800000000ULL - 1ULL; }
U comp(void) { return ~0x400000000000000000ULL; }
S negmin(void) { return -((S)0x400000000000000000ULL); }
int ceq(void) { return (1ULL << 70) == 0x400000000000000000ULL; }
int clt(void) { return ((S)0x400000000000000000ULL) < 0; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    dir="$TMP/$cpu"
    mkdir -p "$dir"
    cp "$TMP/test.c" "$dir/test.c"
    (cd "$dir" && "$KCC" -x="$cpu" -S test.c >/dev/null)
    asm="$dir/test.s"
    if grep -Eiq '^[[:space:]]*(LSHC|ASHC)[[:space:]]' "$asm"; then
        echo "wide constant expression escaped folding on $cpu" >&2
        exit 1
    fi
    block()
    {
        awk -v name="$1" '
            $0 == name ":" { found = 1; next }
            found && /^[A-Za-z_][A-Za-z0-9_]*:/ { exit }
            found { print }
        ' "$asm"
    }

    block l34 | grep -Eiq '^[[:space:]]*MOVSI[[:space:]]+2,0?200000$'
    block l70 | grep -Eiq '^[[:space:]]*MOVSI[[:space:]]+1,0?400000$'
    block r35 | grep -Eiq '^[[:space:]]*MOVEI[[:space:]]+1,1$'
    block r35 | grep -Eiq '^[[:space:]]*SETZ[[:space:]]+2,'
    block ar35 | grep -Eiq '^[[:space:]]*MOVE[[:space:]]+1,\[0?777777777777\]$'
    block ar70 | grep -Eiq '^[[:space:]]*MOVE[[:space:]]+2,\[0?377777777777\]$'
    block ceq | grep -Eiq '^[[:space:]]*MOVEI[[:space:]]+1,1$'
    block clt | grep -Eiq '^[[:space:]]*MOVEI[[:space:]]+1,1$'
done
echo 'DImode wide folded-expression regression passed'
