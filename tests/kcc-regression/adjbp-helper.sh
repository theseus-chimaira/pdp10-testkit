#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-adjbp-helper-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir "$tmp"

cat > "$tmp/adjbp.c" <<'SRC'
char *addvar(char *p, int n)
{
    return p + n;
}

char *subone(char *p)
{
    return p - 1;
}

char *addone(char *p)
{
    return p + 1;
}

typedef signed _KCCtype_char6 c6;
typedef signed _KCCtype_char7 c7;
static c7 castsrc[2];

c6 *castaddone(void)
{
    c7 *p = castsrc;
    c6 *q;

    q = (c6 *)p;
    return q + 1;
}
SRC

(
    cd "$tmp"
    "$KCC" -S -x=pdp6 adjbp.c >/dev/null 2>&1
)

# Variable byte-pointer adjustments still use the shared PDP-6 runtime helper.
# Constant -1 is now lowered to a PDP-6-safe whole-word adjustment plus IBP.
count=$(grep -ic 'pushj[[:space:]]*17,%ADJBPH' "$tmp/adjbp.s" || true)
[ "$count" -eq 1 ]
sub_block=$(sed -n '/^subone:/,/^addone:/p' "$tmp/adjbp.s")
if printf '%s\n' "$sub_block" | grep -q '%ADJBPH'; then
    exit 1
fi
printf '%s\n' "$sub_block" | grep -Eiq '^[[:space:]]*hrrz[[:space:]]+16,0\(17\)'

# A +1 byte-pointer adjustment must use IBP instead of the general helper.
grep -iq 'ibp' "$tmp/adjbp.s"

# When a converted pointer has already been copied out of its incoming ABI
# register, retarget its producer into AC1 before the destructive IBP.  This
# avoids an extra MOVE without redirecting the IBP side effect to a CSE AC.
cast_block=$(awk '
    /^castaddone:/ { in_cast = 1; next }
    in_cast && /^[[:space:]]*$/ { exit }
    in_cast { print }
' "$tmp/adjbp.s")
printf '%s\n' "$cast_block" | grep -Eiq 'ibp[[:space:]]*0?1'
if printf '%s\n' "$cast_block" | grep -Eiq 'move[[:space:]]+0?1,0?[2-7]'; then
    exit 1
fi

# PDP-6 cannot use a low-core effective address as an accumulator-to-accumulator
# transfer.  The simulated ADJBP call must marshal count and pointer through
# stack memory, and the shared helper itself must not contain EXCH 1,16.
if grep -Eiq 'exch[[:space:]]*1,16' "$tmp/adjbp.s"; then
    exit 1
fi
grep -Eq 'MOVEM[[:space:]]+0?[0-7]+,-0?1\(17\)' "$tmp/adjbp.s"
grep -Eq 'MOVEM[[:space:]]+0?[0-7]+,0\(17\)' "$tmp/adjbp.s"
grep -Eq 'MOVE[[:space:]]+0?1,0\(17\)' "$tmp/adjbp.s"
grep -Eq 'MOVE[[:space:]]+0?16,-0?1\(17\)' "$tmp/adjbp.s"
helper_line=$(grep -n '^%ADJBPH:' "$tmp/adjbp.s" | cut -d: -f1)
first_body=$(sed -n "$((helper_line + 1))p" "$tmp/adjbp.s")
printf '%s
' "$first_body" | grep -Eiq 'jumpe[[:space:]]+0?1,'

# The simulation body must be emitted once per translation unit, not once per
# pointer adjustment.
[ "$(grep -c '^%ADJBPH:' "$tmp/adjbp.s")" -eq 1 ]
[ "$(grep -c '^%ADJX' "$tmp/adjbp.s")" -eq 1 ]

echo "ADJBP helper regression passed"
