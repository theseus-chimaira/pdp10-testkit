#!/bin/sh
set -eu
TEST_ROOT=${TEST_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)}
DAS_ROOT=${DAS_ROOT:?set DAS_ROOT to the DAS source tree}
DAS_BIN=${DAS_BIN:-$DAS_ROOT/das}
DXRCHECK_BIN=${DXRCHECK_BIN:-$DAS_ROOT/dxrcheck}
TMPDIR=${TMPDIR:?set TMPDIR to a writable temporary directory}
OUT=${OUT:-$TMPDIR/das-dxr-smoke.$$}
OUT2=${OUT2:-$TMPDIR/das-dxr-reloc.$$}
OUT3=${OUT3:-$TMPDIR/das-dxr-point.$$}
OUT4=${OUT4:-$TMPDIR/das-dxr-include.$$}
OUT5=${OUT5:-$TMPDIR/das-dxr-op-io-byte.$$}
OUT6=${OUT6:-$TMPDIR/das-dxr-convenience.$$}
OUT7=${OUT7:-$TMPDIR/das-dxr-reloc-forms.$$}
OUT8=${OUT8:-$TMPDIR/das-dxr-pseudo-more.$$}
OUT9=${OUT9:-$TMPDIR/das-dxr-strict-base.$$}
OUT10=${OUT10:-$TMPDIR/das-dxr-point-forms.$$}
OUT11=${OUT11:-$TMPDIR/das-dxr-pseudo-alias.$$}
OUT12=${OUT12:-$TMPDIR/das-dxr-strict-base-byte.$$}
OUT13=${OUT13:-$TMPDIR/das-dxr-base-kernel-io.$$}
OUT14=${OUT14:-$TMPDIR/das-dxr-source-compat.$$}
OUT15=${OUT15:-$TMPDIR/das-dxr-reloc-boundary.$$}
OUT16=${OUT16:-$TMPDIR/das-dxr-reloc-symbol-offset.$$}
OUT17=${OUT17:-$TMPDIR/das-dxr-jfcl-alias.$$}
OUT18=${OUT18:-$TMPDIR/das-dxr-word-address-reloc.$$}
OUT19=${OUT19:-$TMPDIR/das-dxr-space-byte-units.$$}
OUT20=${OUT20:-$TMPDIR/das-dxr-mixed-reloc.$$}
OUT21=${OUT21:-$TMPDIR/das-dxr-literal-set-source-order.$$}
OUT22=${OUT22:-$TMPDIR/das-dxr-literal-set-nested.$$}
RELOCS_OUT=${RELOCS_OUT:-$TMPDIR/das-dxr-relocs.$$}
CONV_SIMH=${CONV_SIMH:-$TMPDIR/das-dxr-convert.simh.$$}
CONV_RIM=${CONV_RIM:-$TMPDIR/das-dxr-convert.rim.$$}
CONV_PT=${CONV_PT:-$TMPDIR/das-dxr-convert.pt.$$}
CONV_PDP6=${CONV_PDP6:-$TMPDIR/das-dxr-convert.pdp6.$$}
KCC_TMP_BASE=${KCC_TMP_BASE:-$TMPDIR/das-kcc-corpus.$$}
GCC_TMP_BASE=${GCC_TMP_BASE:-$TMPDIR/das-gcc-corpus.$$}
BAD=${BAD:-$TMPDIR/das-dxr-bad.$$}
SELF=${SELF:-$TMPDIR/das-native-selftest.$$}
COMMENT_SELF=${COMMENT_SELF:-$TMPDIR/das-native-comments-selftest.$$}
cleanup() {
    rm -rf "$OUT" "$OUT.dump" "$RELOCS_OUT" "$CONV_SIMH" "$CONV_RIM" "$CONV_PT" "$CONV_PDP6" "$OUT2" "$OUT3" "$OUT4" "$OUT5" "$OUT6" "$OUT7" "$OUT8" "$OUT9" "$OUT10" "$OUT11" "$OUT12" "$OUT13" "$OUT14" "$OUT15" "$OUT16" "$OUT17" "$OUT18" "$OUT19" "$OUT20" "$OUT21" "$OUT22" "$BAD" "$SELF" "$COMMENT_SELF" "$KCC_TMP_BASE".* "$GCC_TMP_BASE".*
}
trap cleanup 0
trap 'cleanup; exit 1' 1 2 3 15

if [ ! -x "$DAS_BIN" ]; then
    echo "missing das: $DAS_BIN" >&2
    exit 1
fi
if [ ! -x "$DXRCHECK_BIN" ]; then
    echo "missing dxrcheck: $DXRCHECK_BIN" >&2
    exit 1
fi

"$DAS_BIN" -O "$OUT" "$TEST_ROOT/dxr-smoke.s"
"$TEST_ROOT/dxr-expect.py" "$OUT"
"$DXRCHECK_BIN" -q "$OUT"
"$TEST_ROOT/dxrcheck-bad-check.py" "$DXRCHECK_BIN"
"$DXRCHECK_BIN" -d "$OUT" > "$OUT.dump"
"$TEST_ROOT/dxrcheck-dump-check.py" "$OUT.dump"
"$DXRCHECK_BIN" -r "$OUT" > "$RELOCS_OUT"
"$TEST_ROOT/dxrcheck-relocs-check.py" "$RELOCS_OUT"
"$DAS_ROOT/dxrconvert" --simh -b 1000 "$OUT" "$CONV_SIMH"
"$DAS_ROOT/dxrconvert" --rim -b 1000 "$OUT" "$CONV_RIM"
"$DAS_ROOT/dxrconvert" --pt -b 1000 "$OUT" "$CONV_PT"
"$DAS_ROOT/dxrconvert" --pdp6-readin -b 1000 "$OUT" "$CONV_PDP6"
"$TEST_ROOT/dxrconvert-check.py" "$CONV_SIMH" "$CONV_RIM" "$CONV_PT" "$CONV_PDP6"
"$DAS_BIN" -O "$OUT2" "$TEST_ROOT/dxr-reloc.s"
"$TEST_ROOT/dxr-check.py" "$OUT2" 40 0 0 0,35,36
"$DXRCHECK_BIN" -q "$OUT2"
"$DAS_BIN" -O "$OUT3" "$TEST_ROOT/dxr-point-lit.s"
"$TEST_ROOT/dxr-check.py" "$OUT3" 4 0 0 0,2
"$DXRCHECK_BIN" -q "$OUT3"
"$DAS_BIN" -O "$OUT4" "$TEST_ROOT/dxr-include.s"
"$TEST_ROOT/dxr-check.py" "$OUT4" 4 0 0 0,1
"$DXRCHECK_BIN" -q "$OUT4"
"$DAS_BIN" -O "$OUT5" "$TEST_ROOT/dxr-op-io-byte.s"
"$TEST_ROOT/dxr-words-check.py" "$OUT5"
"$DXRCHECK_BIN" -q "$OUT5"
"$DAS_BIN" -O "$OUT6" "$TEST_ROOT/dxr-convenience.s"
"$TEST_ROOT/dxr-convenience-check.py" "$OUT6"
"$DXRCHECK_BIN" -q "$OUT6"
"$DAS_BIN" -O "$OUT7" "$TEST_ROOT/dxr-reloc-forms.s"
"$TEST_ROOT/dxr-reloc-forms-check.py" "$OUT7"
"$DXRCHECK_BIN" -q "$OUT7"
"$DAS_BIN" -O "$OUT18" "$TEST_ROOT/dxr-word-address-reloc.s"
"$TEST_ROOT/dxr-word-address-reloc-check.py" "$OUT18"
"$DXRCHECK_BIN" -q "$OUT18"
"$DAS_BIN" -L "$OUT19.labels" -O "$OUT19" "$TEST_ROOT/dxr-space-byte-units.s"
"$TEST_ROOT/dxr-space-byte-units-check.py" "$OUT19.labels"
"$DXRCHECK_BIN" -q "$OUT19"
rm -f "$OUT19.labels"
"$DAS_BIN" -O "$OUT8" "$TEST_ROOT/dxr-pseudo-more.s"
"$TEST_ROOT/dxr-pseudo-more-check.py" "$OUT8"
"$DXRCHECK_BIN" -q "$OUT8"
"$DAS_BIN" -B -O "$OUT9" "$TEST_ROOT/dxr-strict-base.s"
"$TEST_ROOT/dxr-check.py" "$OUT9" 4 0 0 0,1
"$DXRCHECK_BIN" -q "$OUT9"
"$DAS_BIN" -B -O "$OUT12" "$TEST_ROOT/dxr-strict-base-byte.s"
"$TEST_ROOT/dxr-check.py" "$OUT12" 6 0 0 0,1,2,4
"$DXRCHECK_BIN" -q "$OUT12"
"$DAS_BIN" -K -O "$OUT13" "$TEST_ROOT/dxr-base-kernel-io.s"
"$TEST_ROOT/dxr-check.py" "$OUT13" 2 0 0 -
"$DXRCHECK_BIN" -q "$OUT13"
"$DAS_BIN" -O "$OUT10" "$TEST_ROOT/dxr-point-forms.s"
"$TEST_ROOT/dxr-point-forms-check.py" "$OUT10"
"$DXRCHECK_BIN" -q "$OUT10"
"$DAS_BIN" -O "$OUT11" "$TEST_ROOT/dxr-pseudo-alias.s"
"$TEST_ROOT/dxr-pseudo-alias-check.py" "$OUT11"
"$DXRCHECK_BIN" -q "$OUT11"
"$DAS_BIN" -O "$OUT17" "$TEST_ROOT/dxr-jfcl-alias.s"
"$TEST_ROOT/dxr-jfcl-alias-check.py" "$OUT17"
"$DXRCHECK_BIN" -q "$OUT17"
"$DAS_BIN" -O "$OUT14" "$TEST_ROOT/dxr-source-compat.s"
"$TEST_ROOT/dxr-source-compat-check.py" "$OUT14"
"$DXRCHECK_BIN" -q "$OUT14"
"$DAS_BIN" -O "$OUT15" "$TEST_ROOT/dxr-reloc-boundary.s"
"$TEST_ROOT/dxr-check.py" "$OUT15" 73 0 0 0,71,72
"$DXRCHECK_BIN" -q "$OUT15"
"$DAS_BIN" -O "$OUT16" "$TEST_ROOT/dxr-reloc-symbol-offset.s"
"$TEST_ROOT/dxr-reloc-symbol-offset-check.py" "$OUT16"
"$DXRCHECK_BIN" -q "$OUT16"
"$DAS_BIN" -O "$OUT20" "$TEST_ROOT/dxr-mixed-reloc.s"
"$TEST_ROOT/dxr-check.py" "$OUT20" 4 0 0 0
"$DXRCHECK_BIN" -q "$OUT20"
"$DAS_BIN" -O "$OUT21" "$TEST_ROOT/dxr-literal-set-source-order.s"
"$TEST_ROOT/dxr-literal-set-source-order-check.py" "$OUT21"
"$DXRCHECK_BIN" -q "$OUT21"
"$DAS_BIN" -O "$OUT22" "$TEST_ROOT/dxr-literal-set-nested.s"
"$TEST_ROOT/dxr-literal-set-nested-check.py" "$OUT22"
"$DXRCHECK_BIN" -q "$OUT22"
for badbase in dxr-bad-nonbase.s dxr-bad-nonbase-fp.s dxr-bad-nonbase-df.s dxr-bad-base-io.s; do
    if "$DAS_BIN" -B -O "$BAD" "$TEST_ROOT/$badbase" 2>/dev/null; then
        echo "non-base opcode accepted in strict mode: $badbase" >&2
        exit 1
    fi
done
for badsrc in dxr-bad-leftreloc.s dxr-bad-worddot.s dxr-bad-double-reloc.s dxr-bad-neg-reloc.s dxr-bad-duplicate-symbol.s dxr-bad-malformed-expr.s dxr-bad-owgbp.s dxr-bad-radix.s dxr-bad-pseudo.s; do
    if "$DAS_BIN" -O "$BAD" "$TEST_ROOT/$badsrc" 2>/dev/null; then
        echo "bad relocation was accepted: $badsrc" >&2
        exit 1
    fi
done
${CC:-cc} ${CFLAGS:- -O2 -std=c89} -I"$DAS_ROOT" -DDAS_NATIVE \
    -o "$SELF" "$TEST_ROOT/das-native-selftest.c"
"$SELF"
${CC:-cc} ${CFLAGS:- -O2 -std=c89} -I"$DAS_ROOT" \
    -o "$COMMENT_SELF" "$TEST_ROOT/das-native-comments-selftest.c"
"$COMMENT_SELF"
echo "DAS native C-comment reader contract passed"
CORE_OBJ="$TMPDIR/das-native-core.$$.o"
${CC:-cc} ${CFLAGS:- -O2 -std=c99} -DDAS_NATIVE \
    -DDAS_NATIVE_CORE_ONLY -c -o "$CORE_OBJ" "$DAS_ROOT/das.c"
if command -v size >/dev/null 2>&1; then
    native_bytes=$(size "$SELF" | awk 'NR == 2 { print $1 + $2 + $3 }')
    core_bytes=$(size "$CORE_OBJ" | awk 'NR == 2 { print $1 + $2 + $3 }')
    if [ "$native_bytes" -gt 12000 ]; then
        echo "DAS_NATIVE self-test image grew too large: $native_bytes bytes" >&2
        exit 1
    fi
    if [ "$core_bytes" -gt 4096 ]; then
        echo "DAS_NATIVE numeric core grew too large: $core_bytes bytes" >&2
        exit 1
    fi
fi
rm -f "$CORE_OBJ"
KCC="$PDP10_PREFIX/bin/kcc"
if [ -x "$KCC" ]; then
    KCC_C="$TMPDIR/das-kcc-$$.c"
    KCC_S="$TMPDIR/das-kcc-$$.s"
    KCC_DXR="$TMPDIR/das-kcc-$$.dxr"
    cp "$DAS_ROOT/das.c" "$KCC_C"
    echo "KCC self-assembly: das.c"
    (cd "$TMPDIR" && "$KCC" -DDAS_NATIVE=1 -DDAS_NATIVE_SELFTEST=1 -DDAS_NATIVE_CORE_ONLY=1 -S "$(basename "$KCC_C")" >/dev/null)
    "$DAS_BIN" -O "$KCC_DXR" "$KCC_S"
    "$TEST_ROOT/dxr-selfasm-check.py" "$KCC_DXR"
    "$DXRCHECK_BIN" -q "$KCC_DXR"
    rm -f "$KCC_C" "$KCC_S" "$KCC_DXR"
    for case in basic data branch; do
        echo "KCC corpus case: $case"
        KCC_CASE_DIR="$KCC_TMP_BASE-$case.d"
        KCC_CASE_DXR="$KCC_TMP_BASE-$case.dxr"
        mkdir -p "$KCC_CASE_DIR"
        cp "$TEST_ROOT/kcc-corpus/$case.c" "$KCC_CASE_DIR/$case.c"
        (cd "$KCC_CASE_DIR" && "$KCC" -S "$case.c" >/dev/null)
        "$DAS_BIN" -O "$KCC_CASE_DXR" "$KCC_CASE_DIR/$case.s"
        "$TEST_ROOT/dxr-kcc-corpus-check.py" "$case" "$KCC_CASE_DXR"
        "$DXRCHECK_BIN" -q "$KCC_CASE_DXR"
        rm -rf "$KCC_CASE_DIR" "$KCC_CASE_DXR"
    done
fi

if [ "${GCCPDP10:-}" ]; then
    for case in basic data branch; do
        echo "GCC corpus case: $case"
        GCC_CASE_DIR="$GCC_TMP_BASE-$case.d"
        GCC_CASE_DXR="$GCC_TMP_BASE-$case.dxr"
        mkdir -p "$GCC_CASE_DIR"
        cp "$TEST_ROOT/kcc-corpus/$case.c" "$GCC_CASE_DIR/$case.c"
        (cd "$GCC_CASE_DIR" && "$GCCPDP10" -S "$case.c" >/dev/null)
        cat "$TEST_ROOT/gcc-main-stub.s" >> "$GCC_CASE_DIR/$case.s"
        "$DAS_BIN" -O "$GCC_CASE_DXR" "$GCC_CASE_DIR/$case.s"
        "$TEST_ROOT/dxr-gcc-corpus-check.py" "$case" "$GCC_CASE_DXR"
        "$DXRCHECK_BIN" -q "$GCC_CASE_DXR"
        rm -rf "$GCC_CASE_DIR" "$GCC_CASE_DXR"
    done
fi
echo "das DXR binary and native self-test passed"
