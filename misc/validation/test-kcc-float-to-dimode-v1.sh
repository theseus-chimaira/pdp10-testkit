#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
export TMPDIR="${TMPDIR:-$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-float-dimode-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
cat > "$work/runtime.c" <<'SRC'
long long cv(float x) { return (long long)x; }
int main(void)
{
    long long value;
    long *parts = (long *)&value;
    if (cv(10.5f) != 10LL) return 1;
    if (cv(-10.5f) != -10LL) return 2;
    if (cv(0.5f) != 0LL) return 3;
    if (cv(16777216.0f) != 16777216LL) return 4;
    value = cv(34359738368.0f);
    if (parts[0] != 1 || parts[1] != 0) return 5;
    value = cv(-34359738368.0f);
    if (parts[0] != -1 || (parts[1] & 0377777777777L) != 0)
        return 6;
    return 0;
}
SRC
for cpu in ka10 ki10 ks10; do
    for mode in opt noopt; do
        flags=
        if [ "$mode" = noopt ]; then flags=-n; fi
        "$KCC" -S -v=nostats -x="$cpu" $flags \
            -o "$work/$cpu-$mode.s" "$work/runtime.c"
        "$P10RUN" --machine "$cpu" --mode deposit --exec-mode step \
            --step-limit 1500000 --timeout 25 \
            --workdir "$work/run-$cpu-$mode" \
            --name "kcc-float-dimode-$cpu-$mode-v1" \
            --expect __test_exit=0 \
            "$root/support/crt0-upstream-v1.s" \
            "$work/$cpu-$mode.s" \
            "$root/support/exit-v1.s" "$root/support/abort-v1.s"
        echo "PASS: float to DImode $cpu $mode"
    done
    "$KCC" -S -v=nostats -x="$cpu" \
        -o "$work/950613-$cpu.s" \
        "$root/tests/codegen/upstream-gcc/compile/950613-1.c"
done
"$KCC" -S -v=nostats -x=pdp6 \
    -o "$work/950613-pdp6.s" \
    "$root/tests/codegen/upstream-gcc/compile/950613-1.c"
