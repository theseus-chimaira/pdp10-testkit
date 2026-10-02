#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-cheap-optimizer-1-6-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
int addarg(p, x)
int *p;
int x;
{
    return *p + x;
}

int andarg(p, x)
int *p;
int x;
{
    return *p & x;
}

int addone(p)
int *p;
{
    return *p + 1;
}

int bitzero(x)
int x;
{
    return (x & 0777) == 0;
}

int bithigh(x)
int x;
{
    return (x & 0777000000000) != 0;
}

int storezero(p)
int *p;
{
    *p = 0;
    return 0;
}

int storeones(p)
int *p;
{
    *p = -1;
    return -1;
}

int complement(p)
int *p;
{
    return ~*p;
}

int twice(p)
int *p;
{
    return *p + *p;
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

    x=$(body addarg "$asm")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*add[[:space:]]+1,2'
    if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*move[[:space:]]+3,2'; then
        echo "$cpu: ADD argument retained a copy temporary" >&2
        exit 1
    fi

    x=$(body andarg "$asm")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*and[[:space:]]+1,2'

    x=$(body addone "$asm")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*addi[[:space:]]+1,1'
    if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*movei[[:space:]]+[0-9]+,1'; then
        echo "$cpu: immediate one was materialized in an AC" >&2
        exit 1
    fi

    x=$(body bitzero "$asm")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*trn[en][[:space:]]+1,0?777'
    if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*andi|^[[:space:]]*cai'; then
        echo "$cpu: low-half bit test retained AND/CAI sequence" >&2
        exit 1
    fi

    x=$(body bithigh "$asm")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*tln[en][[:space:]]+1,0?777000'
    if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*andi|^[[:space:]]*cai'; then
        echo "$cpu: high-half bit test retained AND/CAI sequence" >&2
        exit 1
    fi

    x=$(body storezero "$asm")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*setzb[[:space:]]+1,'
    if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*move[[:space:]]+1,'; then
        echo "$cpu: SETZB retained final MOVE into AC1" >&2
        exit 1
    fi

    x=$(body storeones "$asm")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*setob[[:space:]]+1,'
    if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*seto[[:space:]]+1'; then
        echo "$cpu: SETOB retained duplicate SETO in AC1" >&2
        exit 1
    fi

    x=$(body complement "$asm")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*setcm[[:space:]]+1,0\(1\)'
    if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*move[[:space:]]+[0-9]+,0\(1\)'; then
        echo "$cpu: SETCM retained memory-load temporary" >&2
        exit 1
    fi

    x=$(body twice "$asm")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*(add[[:space:]]+([0-9]+),\2|lsh[[:space:]]+[0-9]+,1)' || {
        echo "$cpu: duplicate value was not folded to one-register doubling" >&2
        exit 1
    }
done

echo "cheap optimizer items 1-6 regression passed"
