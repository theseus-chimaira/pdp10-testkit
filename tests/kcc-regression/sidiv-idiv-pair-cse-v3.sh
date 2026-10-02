#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
work="$TMPDIR/kcc-sidiv-idiv-pair-cse-v3-$$"
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"

cat > "$work/t.c" <<'SRC'
volatile int __test_exit;
int gx;
int gy;
int matrix[32][32];

int q_then_r_const(int x)
{
    return (x / 5) * 37 + (x % 5);
}

int r_then_q_const(int x)
{
    return (x % 5) * 37 + (x / 5);
}

int idx_qr_const(void)
{
    return matrix[gx / 5][gx % 5];
}

int idx_rq_const(void)
{
    return matrix[gx % 5][gx / 5];
}

int idx_rq_var(void)
{
    return matrix[gx % gy][gx / gy];
}

int main(void)
{
    gx = 23;
    gy = 5;
    if (q_then_r_const(gx) != 151) return 1;
    if (r_then_q_const(gx) != 115) return 2;

    matrix[4][3] = 403;
    matrix[3][4] = 304;
    if (idx_qr_const() != 403) return 3;
    if (idx_rq_const() != 304) return 4;
    if (idx_rq_var() != 304) return 5;

    gx = -23;
    if (q_then_r_const(gx) != -151) return 6;
    if (r_then_q_const(gx) != -115) return 7;
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

    for fn in q_then_r_const r_then_q_const idx_qr_const idx_rq_const idx_rq_var; do
        n=$(body "$fn" "$asm" | grep -Eic '^[[:space:]]*(idiv|uidiv)i?[[:space:]]' || true)
        if [ "$n" -ne 1 ]; then
            echo "$cpu: $fn emitted $n divisions; expected one shared IDIV pair" >&2
            exit 1
        fi
    done

    "$P10RUN" --machine "$cpu" --mode deposit --exec-mode step \
        --step-limit 3000000 --timeout 20 --workdir "$work/run-$cpu" \
        --name "sidiv-idiv-pair-cse-v3-$cpu" --expect __test_exit=0 \
        "$testroot/semantic-crt0.s" "$asm" "$KCC_RT" >/dev/null
done

printf '%s\n' 'signed IDIV pair CSE regression passed'
