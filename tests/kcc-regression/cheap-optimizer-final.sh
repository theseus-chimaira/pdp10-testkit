#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-cheap-optimizer-final-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
int eqc(x) int x; { return x == 7; }
int nec(x) int x; { return x != 7; }
int ltc(x) int x; { return x < 7; }
int csub(x) int x; { return 7 - x; }
int idx1(p,i) int *p; int i; { return p[i + 1]; }
int idx3(p,i) int *p; int i; { return p[i + 3]; }
int asgn(p,x) int *p; int x; { return (*p = x); }
int asadd(p,x) int *p; int x; { return (*p = x + 1); }
int casadd(p,x) int *p; int x; { return (*p += x); }
int casand(p,x) int *p; int x; { return (*p &= x); }
int casor(p,x) int *p; int x; { return (*p |= x); }
int casxor(p,x) int *p; int x; { return (*p ^= x); }
int dupidx(p,i) int *p; int i; { return p[i] + p[i]; }
int dupand(p,i) int *p; int i; { return p[i] & p[i]; }
int dupor(p,i) int *p; int i; { return p[i] | p[i]; }
signed char ret_sc(x) int x; { return (signed char) x; }
int cmp_sc(x) int x; { signed char y; y = ret_sc(x); return y == (signed char) x; }
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

    for fn in eqc nec ltc; do
        x=$(body "$fn" "$asm")
        printf '%s\n' "$x" | grep -Eiq '^[[:space:]]*cai[a-z]*[[:space:]]+[0-7]+,7'
        if printf '%s\n' "$x" | grep -Eiq '^[[:space:]]*(movei|movni)[[:space:]]+[0-7]+,7'; then
            echo "$cpu: $fn materialized comparison constant 7" >&2
            exit 1
        fi
    done

    x=$(body csub "$asm")
    printf '%s\n' "$x" | grep -Eiq '^[[:space:]]*movn[[:space:]]+1,1'
    printf '%s\n' "$x" | grep -Eiq '^[[:space:]]*addi[[:space:]]+1,7'
    if printf '%s\n' "$x" | grep -Eiq '^[[:space:]]*sub[[:space:]]'; then
        echo "$cpu: constant-minus-variable retained SUB form" >&2
        exit 1
    fi

    x=$(body idx1 "$asm")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*move[[:space:]]+1,1\([0-7]+\)'
    if printf '%s\n' "$x" | grep -Eiq '^[[:space:]]*addi[[:space:]]'; then
        echo "$cpu: p[i+1] retained ADDI address adjustment" >&2
        exit 1
    fi

    x=$(body idx3 "$asm")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*move[[:space:]]+1,3\([0-7]+\)'
    if printf '%s\n' "$x" | grep -Eiq '^[[:space:]]*addi[[:space:]]'; then
        echo "$cpu: p[i+3] retained ADDI address adjustment" >&2
        exit 1
    fi

    x=$(body asgn "$asm")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*movem[[:space:]]+2,0\(1\)'
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*move[[:space:]]+1,2'
    if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*move[[:space:]]+1,3'; then
        echo "$cpu: assignment expression returned an uninitialized temporary" >&2
        exit 1
    fi

    x=$(body asadd "$asm")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*movem[[:space:]]+([0-7]+),0\(1\)'
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*move[[:space:]]+1,[0-7]+'

    for spec in 'casadd:addb' 'casand:andb' 'casor:iorb' 'casxor:xorb'; do
        fn=${spec%%:*}
        op=${spec#*:}
        x=$(body "$fn" "$asm")
        printf '%s\n' "$x" | grep -Eiq "^[[:space:]]*$op[[:space:]]+2,0\\(1\\)"
        printf '%s\n' "$x" | grep -Eq '^[[:space:]]*move[[:space:]]+1,2'
        if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*move[[:space:]]+3,2'; then
            echo "$cpu: $fn retained compound-assignment RHS temporary" >&2
            exit 1
        fi
    done

    x=$(body dupidx "$asm")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*lsh[[:space:]]+1,1'
    loads=$(printf '%s\n' "$x" | grep -Ec '^[[:space:]]*move[[:space:]]+[0-7]+,0\([0-7]+\)' || true)
    [ "$loads" -eq 1 ] || {
        echo "$cpu: duplicate indexed addition performed $loads loads" >&2
        exit 1
    }

    for fn in dupand dupor; do
        x=$(body "$fn" "$asm")
        loads=$(printf '%s\n' "$x" | grep -Ec '^[[:space:]]*move[[:space:]]+1,0\([0-7]+\)' || true)
        [ "$loads" -eq 1 ] || {
            echo "$cpu: $fn did not collapse to one indexed load" >&2
            exit 1
        }
    done

    x=$(body cmp_sc "$asm")
    printf '%s\n' "$x" | grep -Eiq '^[[:space:]]*move[[:space:]]+2,0?10'
    printf '%s\n' "$x" | grep -Eiq '^[[:space:]]*lsh[[:space:]]+2,0?33'
    printf '%s\n' "$x" | grep -Eiq '^[[:space:]]*ash[[:space:]]+2,-0?33'
    if printf '%s\n' "$x" | grep -Eiq '^[[:space:]]*trne[[:space:]]+0?10,0?400'; then
        echo "$cpu: signed-char widening discarded its live destination copy" >&2
        exit 1
    fi
done

echo "final cheap optimizer regression passed"
