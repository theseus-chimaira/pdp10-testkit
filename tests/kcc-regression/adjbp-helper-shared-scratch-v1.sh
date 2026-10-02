#!/bin/sh
set -eu
: "${PDP10_PREFIX:?PDP10_PREFIX must be set}"
: "${TMPDIR:?TMPDIR must be set}"
KCC=${KCC:-$PDP10_PREFIX/bin/kcc}
D="$TMPDIR/kcc-adjbp-helper-shared-scratch-v1"
rm -rf "$D"
mkdir -p "$D"
cat > "$D/t.c" <<'SRC'
char *f(char *p, int i) { return p + i; }
char *g(char *p, int i) { return p + i + 1; }
SRC
(
    cd "$D"
    TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=t t.c >/dev/null
)
S="$D/t.s"
# Both functions need the general helper, but AC13--AC15 must now be
# preserved once in the shared helper rather than around every call site.
[ "$(grep -c 'PUSHJ[[:space:]]*17,%ADJBPH' "$S")" -eq 2 ]
[ "$(grep -c 'PUSH[[:space:]]*17,13' "$S")" -eq 1 ]
[ "$(grep -c 'PUSH[[:space:]]*17,14' "$S")" -eq 1 ]
[ "$(grep -c 'PUSH[[:space:]]*17,15' "$S")" -eq 1 ]
[ "$(grep -c 'POP[[:space:]]*17,13' "$S")" -eq 1 ]
[ "$(grep -c 'POP[[:space:]]*17,14' "$S")" -eq 1 ]
[ "$(grep -c 'POP[[:space:]]*17,15' "$S")" -eq 1 ]
echo "shared ADJBP helper scratch preservation regression passed"
