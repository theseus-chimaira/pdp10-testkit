#!/bin/sh
set -eu

TEST_ROOT=${TEST_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)}
DAS_ROOT=${DAS_ROOT:?set DAS_ROOT to the DAS source tree}
AS_BIN=${AS_BIN:-$DAS_ROOT/pdp10-dec-none-as}
TMPDIR=${TMPDIR:-/tmp}
OUT=${OUT:-$TMPDIR/pdp10-as-ki10-opcodes.$$}
OUT2=${OUT2:-$TMPDIR/pdp10-as-twoword-long-literal.$$}
OUT3=${OUT3:-$TMPDIR/pdp10-as-comma-literal.$$}
OUT4=${OUT4:-$TMPDIR/pdp10-as-at-segments.$$}
OUT5=${OUT5:-$TMPDIR/pdp10-as-point-bare-word.$$}
OUT6=${OUT6:-$TMPDIR/pdp10-as-jfcl-aliases.$$}
AR_BIN=${AR_BIN:-$DAS_ROOT/pdp10-dec-none-ar}
RANLIB_BIN=${RANLIB_BIN:-$DAS_ROOT/pdp10-dec-none-ranlib}
AR_TMP=${AR_TMP:-$TMPDIR/pdp10-ar-test.$$}
EXP=${EXP:-$TMPDIR/pdp10-as-ki10-opcodes.exp.$$}
GOT=${GOT:-$TMPDIR/pdp10-as-ki10-opcodes.got.$$}
ERR=${ERR:-$TMPDIR/pdp10-as-error.$$}
trap 'rm -f "$OUT" "$OUT2" "$OUT3" "$OUT4" "$OUT5" "$OUT6" "$EXP" "$GOT" "$ERR" "$AR_TMP" "$AR_TMP.a"' 0 1 2 3 15

if [ ! -x "$AS_BIN" ]; then
    echo "missing assembler: $AS_BIN" >&2
    exit 1
fi

if [ ! -x "$AR_BIN" ]; then
    echo "missing archive wrapper: $AR_BIN" >&2
    exit 1
fi

if [ ! -x "$RANLIB_BIN" ]; then
    echo "missing ranlib wrapper: $RANLIB_BIN" >&2
    exit 1
fi

"$AS_BIN" --start 0 -o "$OUT" "$TEST_ROOT/ki10-opcodes.s"

grep '^deposit ' "$OUT" > "$GOT"
cat > "$EXP" <<'EOF_EXPECTED'
deposit 0 105040000002
deposit 1 110040000002
deposit 2 111040000002
deposit 3 112040000002
deposit 4 113040000002
deposit 5 114040000002
deposit 6 115040000002
deposit 7 116040000002
deposit 10 117040000002
deposit 11 120040000002
deposit 12 121040000002
deposit 13 122040000002
deposit 14 124040000002
deposit 15 125040000002
deposit 16 126040000002
deposit 17 127040000002
deposit 20 130040000002
deposit 21 131040000002
deposit 22 132040000002
deposit 23 133040000002
deposit 24 133040000002
deposit 25 134040000002
deposit 26 135040000002
deposit 27 136040000002
deposit 30 137040000002
EOF_EXPECTED

if ! cmp -s "$EXP" "$GOT"; then
    echo "assembler opcode test failed" >&2
    echo "expected:" >&2
    cat "$EXP" >&2
    echo "got:" >&2
    cat "$GOT" >&2
    exit 1
fi

"$AS_BIN" --start 0 -o "$OUT2" "$TEST_ROOT/twoword-long-literal.s"

grep '^deposit ' "$OUT2" > "$GOT"
cat > "$EXP" <<'EOF_EXPECTED'
deposit 0 120040000003
deposit 1 110040000005
deposit 2 263740000000
deposit 3 405220011451
deposit 4 012413005637
deposit 5 000000000000
deposit 6 000000000000
EOF_EXPECTED

if ! cmp -s "$EXP" "$GOT"; then
    echo "assembler two-word .long literal test failed" >&2
    echo "expected:" >&2
    cat "$EXP" >&2
    echo "got:" >&2
    cat "$GOT" >&2
    exit 1
fi

"$AS_BIN" --start 0 -o "$OUT3" "$TEST_ROOT/twoword-comma-literal.s"

grep '^deposit ' "$OUT3" > "$GOT"
cat > "$EXP" <<'EOF_EXPECTED'
deposit 0 120200000003
deposit 1 124200000003
deposit 2 263740000000
deposit 3 000000000002
deposit 4 000000012345
EOF_EXPECTED

if ! cmp -s "$EXP" "$GOT"; then
    echo "assembler two-word comma literal test failed" >&2
    echo "expected:" >&2
    cat "$EXP" >&2
    echo "got:" >&2
    cat "$GOT" >&2
    exit 1
fi

"$AS_BIN" --start highfun -o "$OUT4" \
    --at 020 "$TEST_ROOT/at-low.s" \
    --at 040000 "$TEST_ROOT/at-high.s"

grep '^deposit ' "$OUT4" > "$GOT"
cat > "$EXP" <<'EOF_EXPECTED'
deposit 20 263740000000
deposit 40000 260740000020
deposit 40001 263740000000
EOF_EXPECTED

if ! cmp -s "$EXP" "$GOT"; then
    echo "assembler --at multi-origin test failed" >&2
    echo "expected:" >&2
    cat "$EXP" >&2
    echo "got:" >&2
    cat "$GOT" >&2
    exit 1
fi


"$AS_BIN" --start 0 -o "$OUT5" "$TEST_ROOT/point-bare-word.s"

grep '^deposit ' "$OUT5" > "$GOT"
cat > "$EXP" <<'EOF_EXPECTED'
deposit 0 135040000003
deposit 1 135100000005
deposit 2 263740000000
deposit 3 331100000004
deposit 4 000000000000
deposit 5 001100000004
EOF_EXPECTED

if ! cmp -s "$EXP" "$GOT"; then
    echo "assembler bare POINT word test failed" >&2
    echo "expected:" >&2
    cat "$EXP" >&2
    echo "got:" >&2
    cat "$GOT" >&2
    exit 1
fi

"$AS_BIN" --start 0 -o "$OUT6" "$TEST_ROOT/jfcl-aliases.s"

grep '^deposit ' "$OUT6" > "$GOT"
cat > "$EXP" <<'EOF_EXPECTED'
deposit 0 255200000007
deposit 1 255200000007
deposit 2 255100000007
deposit 3 255100000007
deposit 4 255400000007
deposit 5 255400000007
deposit 6 255200000010
deposit 7 263740000000
deposit 10 344040000011
EOF_EXPECTED

if ! cmp -s "$EXP" "$GOT"; then
    echo "assembler JFCL alias test failed" >&2
    echo "expected:" >&2
    cat "$EXP" >&2
    echo "got:" >&2
    cat "$GOT" >&2
    exit 1
fi

"$AS_BIN" --start high_entry \
    --at 20 "$TEST_ROOT/multi-origin-low.s" \
    --at=40 "$TEST_ROOT/multi-origin-high.s" \
             "$TEST_ROOT/multi-origin-tail.s" > "$OUT4"

grep -E '^; label |^deposit |^; segment |^; entry |^go ' "$OUT4" > "$GOT"
cat > "$EXP" <<'EOF_EXPECTED'
; label low_entry 000020
; label low_data 000022
; label low_bss 000024
; label high_entry 000040
; label high_tail 000041
; label high_data 000042
; label high_bss 000043
deposit 20 201040000040
deposit 21 200100000023
deposit 22 000000000042
deposit 23 000000000123
deposit 40 201140000022
deposit 41 263740000000
deposit 42 000000000020
; segment 0 at 20, text 2, data 1, pool 1 at 23, bss at 24, end at 25
; segment 1 at 40, text 2, data 1, pool 0 at 43, bss at 43, end at 45
; entry at 40
go 40
EOF_EXPECTED

if ! cmp -s "$EXP" "$GOT"; then
    echo "assembler segment-layout test failed" >&2
    echo "expected:" >&2
    cat "$EXP" >&2
    echo "got:" >&2
    cat "$GOT" >&2
    exit 1
fi

if "$AS_BIN" --start low_entry \
    --at 20 "$TEST_ROOT/multi-origin-low.s" \
    --at 24 "$TEST_ROOT/multi-origin-high.s" > "$OUT4" 2> "$ERR"; then
    echo "assembler accepted overlapping segments" >&2
    exit 1
fi
if ! grep 'overlap' "$ERR" >/dev/null; then
    echo "assembler overlap diagnostic missing" >&2
    cat "$ERR" >&2
    exit 1
fi

if "$AS_BIN" --at 20 --at 40 "$TEST_ROOT/multi-origin-high.s" \
    > "$OUT4" 2> "$ERR"; then
    echo "assembler accepted an empty --at segment" >&2
    exit 1
fi
if ! grep 'has no input files' "$ERR" >/dev/null; then
    echo "assembler empty-segment diagnostic missing" >&2
    cat "$ERR" >&2
    exit 1
fi

if "$AS_BIN" --at nowhere "$TEST_ROOT/multi-origin-high.s" \
    > "$OUT4" 2> "$ERR"; then
    echo "assembler accepted a symbolic --at origin" >&2
    exit 1
fi
if ! grep 'octal address' "$ERR" >/dev/null; then
    echo "assembler bad-origin diagnostic missing" >&2
    cat "$ERR" >&2
    exit 1
fi

printf 'pdp10 archive wrapper test\n' > "$AR_TMP"
"$AR_BIN" rc "$AR_TMP.a" "$AR_TMP"
"$RANLIB_BIN" "$AR_TMP.a"
if [ ! -s "$AR_TMP.a" ]; then
    echo "archive wrapper test failed" >&2
    exit 1
fi

echo "assembler opcode, POINT, JFCL alias, literal, segment-layout, multi-origin, and archive-wrapper tests passed"
