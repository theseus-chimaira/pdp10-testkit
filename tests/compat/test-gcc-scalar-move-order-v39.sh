#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:?TMPDIR must be set}"
work=$TMPDIR/pdp10-testkit-gcc-scalar-move-order-v39-$$
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"

check_one()
{
        opt=$1
        tag=$2
        asm=$work/$tag.s
        body=$work/$tag-body.s

        "$PDP10_GCC" -S "$opt" -o "$asm" \
                "$root/tests/compat/gcc-scalar-move-order-v39.c"

        awk '
/^gcc_scalar_move_order_v39:/ { in_fn = 1 }
in_fn { print }
in_fn && /^[[:space:]]*popj[[:space:]]+17,/ { exit }
' "$asm" > "$body"

        grep -q 'pushj[[:space:]]*17,find_slot' "$body"

        if awk '
/pushj[[:space:]]*17,find_slot/ { after = 1; next }
after && /^[[:space:]]*move[[:space:]]+3,2([[:space:]]|$)/ { bad = 1 }
after && /^[[:space:]]*move[[:space:]]+2,1([[:space:]]|$)/ {
        if (bad) exit 1;
        found = 1;
        exit 0;
}
END { if (!found) exit 2 }
' "$body"; then
                :
        else
                rc=$?
                cat "$body" >&2
                if test "$rc" -eq 1; then
                        echo "gcc scalar move-order regression ($opt): stale AC2 used before returned AC1 is saved" >&2
                else
                        echo "gcc scalar move-order regression ($opt): expected return-value save not found" >&2
                fi
                exit 1
        fi
}

check_one -O2 o2
check_one -Os os

printf '%s\n' 'GCC scalar move-order regression passed (-O2, -Os)'
