#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-sidiv-helper-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir "$tmp"

cat > "$tmp/sidiv.c" <<'SRC'
long sdiv(long a, long b)
{
    return a / b;
}
SRC

(
    cd "$tmp"
    "$KCC" -S -x=pdp6 sidiv.c >/dev/null 2>&1
)

# The PDP-6 signed-division edge path needs the magnitude of the divisor.
# MOVM computes it directly.  The source is an AC referenced through the
# instruction address field, so force octal syntax there: bare 16 is decimal
# address 16 to DAS, not AC16 (octal 016).
grep -iq 'movm[[:space:]]*15,016' "$tmp/sidiv.s"
! grep -iq 'jumpge[[:space:]]*15,%SIDP' "$tmp/sidiv.s"
! grep -iq 'movn[[:space:]]*15,15' "$tmp/sidiv.s"
grep -iq 'move[[:space:]]*16,015' "$tmp/sidiv.s"
grep -iq 'jumpl[[:space:]]*16,%UIDN' "$tmp/sidiv.s"
! grep -iq 'skipge[[:space:]]*16,16' "$tmp/sidiv.s"
grep -iq 'aoja[[:space:]]*[0-7][0-7]*,%UIDD' "$tmp/sidiv.s"

echo "signed divide helper regression passed"
