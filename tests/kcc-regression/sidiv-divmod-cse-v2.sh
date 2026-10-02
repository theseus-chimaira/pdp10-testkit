#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
work="$TMPDIR/kcc-sidiv-divmod-cse-v2-$$"
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"

cat > "$work/t.c" <<'SRC'
volatile int __test_exit;
volatile int vx, vy;
int matrix[7][7];

int q_then_r(x, y)
int x, y;
{
    int q, r;
    q = x / y;
    r = x % y;
    return q * 100 + r;
}

int r_then_q(x, y)
int x, y;
{
    int q, r;
    r = x % y;
    q = x / y;
    return q * 100 + r;
}

int direct_index(x, y)
int x, y;
{
    return matrix[x % y][x / y];
}

unsigned int uq_then_r(x, y)
unsigned int x, y;
{
    unsigned int q, r;
    q = x / y;
    r = x % y;
    return q * 100U + r;
}

unsigned int ur_then_q(x, y)
unsigned int x, y;
{
    unsigned int q, r;
    r = x % y;
    q = x / y;
    return q * 100U + r;
}

int main(void)
{
    vx = 23;
    vy = 5;
    if (q_then_r(vx, vy) != 403) return 1;
    if (r_then_q(vx, vy) != 403) return 2;
    matrix[3][4] = 1234;
    matrix[4][3] = 567;
    if (direct_index(vx, vy) != 1234) return 3;
    if (uq_then_r(23U, 5U) != 403U) return 6;
    if (ur_then_q(23U, 5U) != 403U) return 7;

    vx = -23;
    vy = 5;
    if (q_then_r(vx, vy) != -403) return 4;
    if (r_then_q(vx, vy) != -403) return 5;
    return 0;
}
SRC

body()
{
    awk -v fn="$1" '
        $0 == fn ":" { in_fn=1; next }
        in_fn && /^[A-Za-z_][A-Za-z0-9_]*:/ { exit }
        in_fn { print }
    ' "$2"
}

for cpu in pdp6 ka10 ki10 ks10; do
    d="$work/$cpu"
    mkdir -p "$d"
    cp "$work/t.c" "$d/t.c"
    (
        cd "$d"
        TERM=dumb "$KCC" -S -v=nostats -x="$cpu" -O -R=t t.c >/dev/null
    )
    asm="$d/t.s"

    for fn in q_then_r r_then_q direct_index uq_then_r ur_then_q; do
        n=$(body "$fn" "$asm" | grep -Eic '^[[:space:]]*(idiv|uidiv)i?[[:space:]]' || true)
        if [ "$n" -ne 1 ]; then
            echo "$cpu: $fn emitted $n divisions; expected one shared quotient/remainder IDIV" >&2
            exit 1
        fi
    done

    "$P10RUN" --machine "$cpu" --mode deposit --exec-mode step \
        --step-limit 3000000 --timeout 20 --workdir "$work/run-$cpu" \
        --name "sidiv-divmod-cse-v2-$cpu" --expect __test_exit=0 \
        "$testroot/semantic-crt0.s" "$asm" "$KCC_RT" >/dev/null
done

printf '%s\n' 'signed DIV/MOD CSE regression passed'
