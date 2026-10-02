#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
: "${TMPDIR:?TMPDIR must be set}"
TMP=$TMPDIR/kcc-double-store-forward-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
volatile double vd;

double forwarded(a, b)
double a, b;
{
    double d;

    d = a - b;
    if (d < 0.0)
        return -d;
    return d;
}

double volatile_reload(x)
double x;
{
    vd = x;
    return vd;
}
SRC

body()
{
    awk -v fn="$1" '
        $0 == fn ":" { in_fn = 1; next }
        in_fn && $0 ~ /^[A-Za-z_][A-Za-z0-9_]*:$/ { exit }
        in_fn { print }
    ' "$2"
}

forwarded_pair()
{
    cpu=$1
    asm=$2
    body forwarded "$asm" | awk -v cpu="$cpu" '
        BEGIN { have_store = 0; found = 0 }
        {
            op = $1
            arg = $2
            if (cpu == "ki10") {
                if (op == "dmovem") {
                    split(arg, a, ",")
                    if (a[2] == "-1(17)") {
                        src = a[1]
                        have_store = 1
                        next
                    }
                }
                if (have_store && op == "dmove") {
                    split(arg, a, ",")
                    if (a[2] == src)
                        found = 1
                    have_store = 0
                } else if (have_store && op != "dmovem")
                    have_store = 0
            } else {
                if (op == "movem") {
                    split(arg, a, ",")
                    if (a[2] == "-1(17)") {
                        src = a[1] + 0
                        have_store = 1
                        next
                    }
                    if (have_store == 1 && a[2] == "0(17)" && (a[1] + 0) == src + 1) {
                        have_store = 2
                        next
                    }
                }
                if (have_store == 2 && op == "move") {
                    split(arg, a, ",")
                    if ((a[2] + 0) == src) {
                        first_move = a[1] + 0
                        have_store = 3
                        next
                    }
                    have_store = 0
                } else if (have_store == 3 && op == "move") {
                    split(arg, a, ",")
                    if ((a[2] + 0) == src + 1 && (a[1] + 0) == first_move + 1)
                        found = 1
                    have_store = 0
                } else if (have_store && op != "movem")
                    have_store = 0
            }
        }
        END { if (!found) exit 1 }
    '
}

for cpu in pdp6 ka10 pdp10 ki10; do
    d="$TMP/$cpu"
    mkdir "$d"
    cp "$TMP/test.c" "$d/test.c"
    (cd "$d" && "$KCC" -x="$cpu" -D__PDP10__ -S test.c >/dev/null)
    asm="$d/test.s"

    fwd=$(body forwarded "$asm")
    vol=$(body volatile_reload "$asm")

    if ! forwarded_pair "$cpu" "$asm"; then
        echo "$cpu: double-word store was not forwarded into the immediate reload" >&2
        exit 1
    fi

    if [ "$cpu" = ki10 ]; then
        printf '%s\n' "$vol" | grep -Eq 'dmovem[[:space:]]+[1-7],vd'
        printf '%s\n' "$vol" | grep -Eq 'movei[[:space:]]+[1-7],vd'
        printf '%s\n' "$vol" | grep -Eq 'dmove[[:space:]]+[1-7],0\([1-7]\)'
    else
        printf '%s\n' "$vol" | grep -Eq 'movem[[:space:]]+[1-7],vd'
        printf '%s\n' "$vol" | grep -Eq 'movem[[:space:]]+[1-7],vd\+1'
        printf '%s\n' "$vol" | grep -Eq 'movei[[:space:]]+[1-7],vd'
        printf '%s\n' "$vol" | grep -Eq 'move[[:space:]]+[1-7],0\([1-7]\)'
        printf '%s\n' "$vol" | grep -Eq 'move[[:space:]]+[1-7],1\([1-7]\)'
    fi
done

echo "double-word store forwarding regression passed"
