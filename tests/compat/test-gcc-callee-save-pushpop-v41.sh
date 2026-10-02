#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:?TMPDIR must be set}"
work=$TMPDIR/pdp10-testkit-gcc-callee-save-pushpop-v41-$$
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"

function_body()
{
        asm=$1
        fn=$2
        out=$3

        awk -v fn="$fn" '
$0 == fn ":" { in_fn = 1 }
in_fn { print }
in_fn && /^[[:space:]]*popj[[:space:]]+17,/ { exit }
' "$asm" > "$out"
}

instruction_count()
{
        awk '
/^[[:space:]]*[A-Za-z][A-Za-z0-9]*[[:space:]]/ { n++ }
END { print n + 0 }
' "$1"
}

check_cpu()
{
        cpu=$1
        o1=$work/$cpu-o1.s
        os=$work/$cpu-os.s

        "$PDP10_GCC" -S -O1 -mcpu="$cpu" -o "$o1" \
                "$root/tests/compat/gcc-callee-save-pushpop-v41.c"
        "$PDP10_GCC" -S -Os -mcpu="$cpu" -o "$os" \
                "$root/tests/compat/gcc-callee-save-pushpop-v41.c"

        for fn in save2 save3; do
                b1=$work/$cpu-$fn-o1.s
                bs=$work/$cpu-$fn-os.s
                function_body "$o1" "$fn" "$b1"
                function_body "$os" "$fn" "$bs"

                case "$fn" in
                save2) n=2 ;;
                save3) n=3 ;;
                esac

                pushes=$(grep -c '^[[:space:]]*push[[:space:]]' "$bs" || true)
                pops=$(grep -c '^[[:space:]]*pop[[:space:]]' "$bs" || true)
                if test "$pushes" -ne "$n" || test "$pops" -ne "$n"; then
                        cat "$bs" >&2
                        echo "gcc callee-save push/pop regression: $cpu $fn: expected $n PUSH and $n POP" >&2
                        exit 1
                fi

                if grep -Eq '^[[:space:]]*(add|sub|adjsp)[[:space:]]+0?17,' "$bs"; then
                        cat "$bs" >&2
                        echo "gcc callee-save push/pop regression: $cpu $fn: redundant stack adjustment remains" >&2
                        exit 1
                fi

                n1=$(instruction_count "$b1")
                ns=$(instruction_count "$bs")
                if test "$ns" -ge "$n1"; then
                        echo "gcc callee-save push/pop regression: $cpu $fn: -Os=$ns is not smaller than -O1=$n1" >&2
                        exit 1
                fi
        done

        "$P10RUN" --machine "$cpu" --mode deposit --exec-mode step \
                --step-limit 1000000 --timeout 20 \
                --workdir "$work/run-$cpu" --name "gcc-callee-save-$cpu-v41" \
                --expect __test_exit=0 \
                "$root/support/crt0.s" \
                "$root/tests/compat/mixed-call-support.s" "$os" >/dev/null
}

check_cpu pdp6
check_cpu ka10

printf '%s\n' 'GCC callee-save PUSH/POP regression passed (PDP-6, KA10)'
