#!/bin/sh
# A compound assignment must preserve its store and single lvalue evaluation.
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
kcc=${KCC_BIN:-$KCC}
work=$TMPDIR/kcc-compound-negating-assign-v1-$$
trap 'rm -rf "$work"' 0 1 2 3 15
mkdir -p "$work"

cat >"$work/cases.c" <<'EOF'
volatile int __test_exit;
int negmul(int x) { x *= -1; return x; }
int negdiv(int x) { x /= -1; return x; }
int negxor(int x) { x ^= -1; return x; }
float floatmul(float x) { x *= -1.0f; return x; }
float floatdiv(float x) { x /= -1.0f; return x; }

int main(void)
{
    int a[3];
    int *p;
    unsigned int u;
    float f;

    if (negmul(7) != -7 || negdiv(-9) != 9 || negxor(7) != ~7)
        return 1;
    a[0] = 11;
    a[1] = -12;
    a[2] = 13;
    p = a;
    *p++ *= -1;
    if (p != &a[1] || a[0] != -11)
        return 2;
    *p++ /= -1;
    if (p != &a[2])
        return 31;
    if (a[1] != 12)
        return 32;
    *p++ ^= -1;
    if (p != &a[3] || a[2] != ~13)
        return 4;
    u = 5U;
    u *= -1;
    if (u != (unsigned int)(0U - 5U))
        return 5;
    f = 3.0f;
    f *= -1.0f;
    if (f != -3.0f || floatmul(4.0f) != -4.0f)
        return 6;
    f /= -1.0f;
    if (f != 3.0f || floatdiv(-6.0f) != 6.0f)
        return 7;
    return 0;
}
EOF

for cpu in pdp6 ka10 ki10 ks10; do
for mode in opt noopt; do
    flags=-O
    if [ "$mode" = noopt ]; then flags=-n; fi
    "$kcc" -Pgnu99 -S -v=nostats -x="$cpu" "$flags" -m=gas \
        -o "$work/cases-$cpu-$mode.s" "$work/cases.c" \
        >"$work/compile-$cpu-$mode.log" 2>&1
    if grep -F 'Discarding expression without side effects' \
            "$work/compile-$cpu-$mode.log" >/dev/null; then
        echo "KCC $cpu $mode incorrectly discarded compound assignment" >&2
        cat "$work/compile-$cpu-$mode.log" >&2
        exit 1
    fi
    "$P10RUN" --machine "$cpu" --mode deposit --exec-mode step \
        --step-limit 1000000 --timeout 25 \
        --workdir "$work/run-$cpu-$mode" \
        --name "kcc-compound-negating-assign-$cpu-$mode-v1" \
        --expect __test_exit=0 \
        "$testroot/semantic-crt0.s" "$work/cases-$cpu-$mode.s" \
        >"$work/run-$cpu-$mode.log" 2>&1 || {
            cat "$work/run-$cpu-$mode.log" >&2
            exit 1
        }
done
done

echo 'KCC compound negative-one assignment: four CPUs, two modes PASS'
