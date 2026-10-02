#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-ka10-double-add-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

if ! command -v "$P10RUN" >/dev/null 2>&1 && [ ! -x "$P10RUN" ]; then
    echo "ka10 double add runtime test: P10RUN not found" >&2
    exit 77
fi

cat > "$TMP/test.c" <<'SRC'
volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;

static double add2(a, b)
double a;
double b;
{
    return a + b;
}

static double mul2(a, b)
double a;
double b;
{
    return a * b;
}

static double div2(a, b)
double a;
double b;
{
    return a / b;
}

int main()
{
    double x;
    float f;

    fail_id = 0;
    x = add2(4.75, 2.5);
    got = (int)x;
    if (got != 7) { fail_id = 1; return 1; }

    f = x - 1.25;
    got1 = (int)f;
    if (got1 != 6) { fail_id = 2; return 1; }

    x = x + 3.0;
    got2 = (int)x;
    if (got2 != 10) { fail_id = 3; return 1; }

    f = mul2(2.0f, 3.0f);
    got3 = (int)f;
    if (got3 != 6) { fail_id = 4; return 1; }

    x = div2(40.0, 2.0);
    got4 = (int)x;
    if (got4 != 20) { fail_id = 5; return 1; }

    return 0;
}
SRC

for cpu in ka10 ki10; do
    for target in ka10 base pdp10; do
        if [ "$cpu" = ki10 ] && [ "$target" = ka10 ]; then
            continue
        fi
        d="$TMP/$cpu-$target"
        mkdir -p "$d"
        cp "$TMP/test.c" "$d/test.c"
        (cd "$d" && "$KCC" -S -v=nostats -x="$target" test.c >/dev/null)
        "$P10RUN" --machine "$cpu" --mode deposit --exec-mode step \
            --start 1000 --step-limit 1000000 --timeout 10 \
            --workdir "$d/run" --name test \
            --expect __test_exit=0 --expect fail_id=0 \
            --examine got --examine got1 --examine got2 \
            --examine got3 --examine got4 \
            "$testroot/semantic-crt0.s" "$d/test.s" "$root/ka10rt.s" >/dev/null
        echo "$cpu $target KA double-add runtime passed"
    done
done
