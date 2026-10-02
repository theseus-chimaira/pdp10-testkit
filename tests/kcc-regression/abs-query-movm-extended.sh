#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-abs-query-movm-extended-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
struct pair { int a; int b; };
int ga[8];
volatile int vv;

int lt(x) int x; { return x < 0 ? -x : x; }
int le(x) int x; { return x <= 0 ? -x : x; }
int gt(x) int x; { return x > 0 ? x : -x; }
int ge(x) int x; { return x >= 0 ? x : -x; }
int zgt(x) int x; { return 0 > x ? -x : x; }
int zge(x) int x; { return 0 >= x ? -x : x; }
int zlt(x) int x; { return 0 < x ? x : -x; }
int zle(x) int x; { return 0 <= x ? x : -x; }

int arr(i) int i; { return ga[i] < 0 ? -ga[i] : ga[i]; }
int member(p) struct pair *p; { return p->b >= 0 ? p->b : -p->b; }
void arrms(i) int i; { ga[i] = ga[i] <= 0 ? -ga[i] : ga[i]; }

int no_side(i) int i; { return ga[i++] < 0 ? -ga[i++] : ga[i++]; }
int no_volatile() { return vv >= 0 ? vv : -vv; }
SRC

body()
{
    awk -v fn="$1" '$0 == fn ":" {p=1; next} /^[A-Za-z_][A-Za-z0-9_]*:/ {if(p) exit} p' "$2"
}

for target in pdp6 ka10 ki10 ks10; do
    d="$TMP/$target"
    mkdir -p "$d"
    cp "$TMP/test.c" "$d/test.c"
    (
        cd "$d"
        "$KCC" -x=$target -D__PDP10__ -S test.c >/dev/null
    )
    asm="$d/test.s"

    for fn in lt le gt ge zgt zge zlt zle arr member; do
        x=$(body "$fn" "$asm")
        printf '%s\n' "$x" | grep -Eq '^[[:space:]]*movm[[:space:]]'
        if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*(skip|jump|cam|jrst)[a-z]*[[:space:]]'; then
            echo "$target/$fn retained conditional absolute-value code" >&2
            exit 1
        fi
    done

    x=$(body arrms "$asm")
    printf '%s\n' "$x" | grep -Eq '^[[:space:]]*movms[[:space:]]'

    x=$(body no_side "$asm")
    if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*movm[s|m]?[[:space:]]'; then
        echo "$target side-effecting array index was incorrectly folded" >&2
        exit 1
    fi

    x=$(body no_volatile "$asm")
    if printf '%s\n' "$x" | grep -Eq '^[[:space:]]*movm[s|m]?[[:space:]]'; then
        echo "$target volatile absolute value was incorrectly folded" >&2
        exit 1
    fi
done

echo "extended absolute-value MOVM regression passed"
