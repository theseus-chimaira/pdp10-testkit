#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-cheap-optimizer-pass-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
int glob;

int incp(p)
int *p;
{
    return ++*p;
}

int decp(p)
int *p;
{
    return --*p;
}

int same_load(x)
int x;
{
    int a;
    a = glob;
    x *= 3;
    return a + glob + x;
}

int copy_store(p, x)
int *p;
int x;
{
    x += *p;
    *p = x;
    return x;
}

long long pair_store(p, x)
long long *p;
long long x;
{
    *p = x;
    return *p;
}
SRC

body()
{
    awk -v fn="$1" '$0 == fn ":" {p=1; next} /^[A-Za-z_][A-Za-z0-9_]*:/ {if(p) exit} p' "$2"
}

for cpu in pdp6 ka10 ki10 ks10; do
    d="$TMP/$cpu"
    mkdir -p "$d"
    cp "$TMP/test.c" "$d/test.c"
    (
        cd "$d"
        "$KCC" -x="$cpu" -D__PDP10__ -S test.c >/dev/null
    )
    asm="$d/test.s"

    x=$(body incp "$asm")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*aos[[:space:]]+1,'
    if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*move[[:space:]]+1,'; then
        echo "$cpu: ++*p retained a final MOVE into AC1" >&2
        exit 1
    fi

    x=$(body decp "$asm")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*sos[[:space:]]+1,'
    if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*move[[:space:]]+1,'; then
        echo "$cpu: --*p retained a final MOVE into AC1" >&2
        exit 1
    fi

    x=$(body same_load "$asm")
    if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*add[[:space:]]+[0-9]+,glob'; then
        echo "$cpu: repeated load of glob was not reused" >&2
        exit 1
    fi

    x=$(body copy_store "$asm")
    if printf '%s\n' "$x" | awk '
        BEGIN { p = ""; bad = 0 }
        /^[[:space:]]*move[[:space:]]+[0-9]+,[0-9]+[[:space:]]*$/ { p = $0; next }
        /^[[:space:]]*movem[[:space:]]+/ { if (p != "") bad = 1 }
        { p = "" }
        END { exit bad ? 0 : 1 }
    '; then
        echo "$cpu: MOVE temporary followed by MOVEM was not coalesced" >&2
        exit 1
    fi

done

for cpu in ki10 ks10; do
    asm="$TMP/$cpu/test.s"
    x=$(body pair_store "$asm")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*DMOVE[[:space:]]|^[[:space:]]*dmove[[:space:]]'
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*DMOVEM[[:space:]]|^[[:space:]]*dmovem[[:space:]]'
done

echo "cheap optimizer pass regression passed"
