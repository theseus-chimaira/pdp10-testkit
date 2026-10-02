#!/bin/sh
set -eu

testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env

TMP=${TMPDIR:?TMPDIR must be set}/kcc-identical-pure-fold-v1-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
extern int side(void);

int add_self(x) int x; { return x + x; }
int sub_self(x) int x; { return x - x; }
int and_self(x) int x; { return x & x; }
int or_self(x) int x; { return x | x; }
int xor_self(x) int x; { return x ^ x; }
int xor_calls(void) { return side() ^ side(); }
int xor_volatile(p) volatile int *p; { return *p ^ *p; }
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

    x=$(body add_self "$asm")
    printf '%s\n' "$x" | grep -Eiq '^[[:space:]]*lsh[[:space:]]+1,0?1'
    if printf '%s\n' "$x" | grep -Eiq '^[[:space:]]*(move|add)[[:space:]]'; then
        echo "$cpu: add_self retained copy/add sequence" >&2
        exit 1
    fi

    for fn in sub_self xor_self; do
        x=$(body "$fn" "$asm")
        printf '%s\n' "$x" | grep -Eiq '^[[:space:]]*setz[[:space:]]+1,'
        if printf '%s\n' "$x" | grep -Eiq '^[[:space:]]*(move|sub|xor)[[:space:]]'; then
            echo "$cpu: $fn retained operand evaluation" >&2
            exit 1
        fi
    done

    for fn in and_self or_self; do
        x=$(body "$fn" "$asm")
        if printf '%s\n' "$x" | grep -Eiq '^[[:space:]]*(move|and|ior)[[:space:]]'; then
            echo "$cpu: $fn retained redundant operation" >&2
            exit 1
        fi
    done

    x=$(body xor_calls "$asm")
    calls=$(printf '%s\n' "$x" | grep -Eic '^[[:space:]]*pushj[[:space:]]+17,side' || true)
    [ "$calls" -eq 2 ] || {
        echo "$cpu: xor_calls lost side effects ($calls calls)" >&2
        exit 1
    }

    x=$(body xor_volatile "$asm")
    loads=$(printf '%s\n' "$x" | grep -Eic '^[[:space:]]*move[[:space:]]+[0-7]+,0\([0-7]+\)' || true)
    [ "$loads" -ge 2 ] || {
        echo "$cpu: xor_volatile lost a volatile access ($loads loads)" >&2
        exit 1
    }
done

echo "identical pure-expression fold regression passed"
