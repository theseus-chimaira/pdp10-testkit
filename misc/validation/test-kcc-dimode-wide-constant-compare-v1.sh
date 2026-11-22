#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
export TMPDIR="${TMPDIR:-$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-dimode-wide-cmp-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
cat >"$work/compare.c" <<'SRC'
long long value;
long long negative;
int main(void)
{
    value = 34359738368LL;
    negative = -34359738368LL;
    if (value != 34359738368LL) return 1;
    if (34359738368LL != value) return 2;
    if (value == 0LL) return 3;
    if (value == 34359738368LL ? 0 : 1) return 4;
    if (negative != -34359738368LL) return 5;
    if (-34359738368LL != negative) return 6;
    if (negative == 0LL) return 7;
    if (value == 0LL || negative == 0LL) return 8;
    if (0LL != 0LL) return 9;
    if (0LL == 0LL ? 0 : 1) return 10;
    return 0;
}
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    for mode in opt noopt; do
        flags=
        if [ "$mode" = noopt ]; then flags=-n; fi
        "$KCC" -S -v=nostats -x="$cpu" $flags \
            -o "$work/$cpu-$mode.s" "$work/compare.c"
        "$P10RUN" --machine "$cpu" --mode deposit --exec-mode step \
            --step-limit 1500000 --timeout 25 \
            --workdir "$work/run-$cpu-$mode" \
            --name "kcc-dimode-wide-cmp-$cpu-$mode-v1" \
            --expect __test_exit=0 \
            "$root/support/crt0-upstream-v1.s" \
            "$work/$cpu-$mode.s" \
            "$root/support/exit-v1.s" "$root/support/abort-v1.s"
        echo "PASS: wide DImode constant comparisons $cpu $mode"
    done
done
