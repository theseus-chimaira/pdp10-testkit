#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-peephole-return-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir "$tmp"

cat > "$tmp/return.c" <<'SRC'
unsigned slots[32];
unsigned startv[1];

int f(unsigned start)
{
    unsigned total;
    unsigned i;

    total = startv[0];
    if (total >= 16U)
        return -1;
    for (i = total; i > start; i--)
        slots[i] = slots[i - 1U];
    return 0;
}
SRC

(
    cd "$tmp"
    "$KCC" -S -x=pdp6 return.c >/dev/null 2>&1
)

# The broken optlab() fold emitted this sequence for the unsigned comparison:
#     CAML ...
#      SKIPA 1,[-1]
#      JRST  return_label
# which returns for total < 16 instead of total >= 16.  Reject that exact
# control-flow shape in this focused reproducer.
awk '
    prev ~ /^[[:space:]]*skipa[[:space:]]+1,\[-1\]/ &&
        $0 ~ /^[[:space:]]*jrst[[:space:]]+/ { bad = 1 }
    { prev = $0 }
    END { exit bad ? 1 : 0 }
' "$tmp/return.s"

echo "peephole conditional-return regression passed"
