#!/bin/sh
set -eu

TEST_ROOT=${TEST_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)}
DAS_ROOT=${DAS_ROOT:?set DAS_ROOT to the DAS source tree}
CC=${CC:-cc}
CFLAGS=${CFLAGS:--O2 -std=c89}
TMPDIR=${TMPDIR:?set TMPDIR to a writable temporary directory}
BASE=$TMPDIR/das-fast-$$
SELF=$BASE-self
NATIVE_COMMENTS=$BASE-native-comments
STORE=$BASE-store
ARGV=$BASE-argv
PARSER=$BASE-parser
MKS6=$BASE-mks6
MKU9=$BASE-mku9
ASCII=$BASE-ascii.dxr
UTF9SRC=$BASE-utf9.s
UTF9=$BASE-utf9.dxr
S6SRC=$BASE-s6rec.s6r
S6=$BASE-s6rec.dxr
COMMON=$BASE-common.dxr
COMMON_LABELS=$BASE-common.labels
COMMON_BSS=$BASE-common-bss.dxr
LONG_DECIMAL=$BASE-long-decimal.dxr
GCC_SYNTAX=$BASE-gcc-syntax.dxr
GCC_SYNTAX_LABELS=$BASE-gcc-syntax.labels
GCC_KL10_DATA=$BASE-gcc-kl10-data.dxr
GLOBL=$BASE-globl.dxr
LIT_DEDUP=$BASE-lit-dedup.dxr
NESTED_LIT=$BASE-nested-lit.dxr
BAD_SPACE=$BASE-bad-space.dxr
EXTENDED_OPS=$BASE-extended-ops.dxr
SIMH_EXTRA_OPS=$BASE-simh-extra-ops.dxr
SYMBOL_ASSIGN=$BASE-symbol-assign.dxr
ASSIGN_DIRECTIVES=$BASE-assign-directives.dxr
BAD_ASSIGN=$BASE-bad-assign.dxr
POINT_DEFAULT=$BASE-point-default.dxr
POINT_MINUS1=$BASE-point-minus1.dxr
BYTE_EXPR=$BASE-byte-expr.dxr
ALIGN=$BASE-align.dxr
BLOCK_EXPR=$BASE-block-expr.dxr
BLOCK_EXPR_LABELS=$BASE-block-expr.labels
ORG=$BASE-org.dxr
COND=$BASE-cond.dxr
COND_REPT=$BASE-cond-rept.dxr
IRP=$BASE-irp-irpc.dxr
JUMP_JRST=$BASE-jump-jrst.dxr
MACRO=$BASE-macro.dxr
MACRO_OPT=$BASE-macro-opt.dxr
MACRO_LABELS=$BASE-macro-opt.labels
EXPR=$BASE-expr.dxr
BAD_EXPR=$BASE-bad-expr.dxr
DIAG=$BASE-diag.txt
trap 'rm -f "$SELF" "$NATIVE_COMMENTS" "$STORE" "$ARGV" "$PARSER" "$MKS6" "$MKU9" "$ASCII" "$UTF9SRC" "$UTF9" "$S6SRC" "$S6" "$COMMON" "$COMMON_LABELS" "$COMMON_BSS" "$LONG_DECIMAL" "$GCC_SYNTAX" "$GCC_SYNTAX_LABELS" "$GCC_KL10_DATA" "$LIT_DEDUP" "$NESTED_LIT" "$BAD_SPACE" "$EXTENDED_OPS" "$SIMH_EXTRA_OPS" "$SYMBOL_ASSIGN" "$ASSIGN_DIRECTIVES" "$BAD_ASSIGN" "$POINT_DEFAULT" "$POINT_MINUS1" "$BYTE_EXPR" "$ALIGN" "$BLOCK_EXPR" "$BLOCK_EXPR_LABELS" "$ORG" "$COND" "$COND_REPT" "$IRP" "$JUMP_JRST" "$MACRO" "$MACRO_OPT" "$MACRO_LABELS" "$EXPR" "$BAD_EXPR" "$DIAG"' 0 1 2 3 15

$CC $CFLAGS -I"$DAS_ROOT" -o "$SELF" "$TEST_ROOT/das-input-selftest.c"
"$SELF"
$CC $CFLAGS -I"$DAS_ROOT" -o "$NATIVE_COMMENTS" \
    "$TEST_ROOT/das-native-comments-selftest.c"
"$NATIVE_COMMENTS"
echo "DAS native C-comment reader contract passed"
$CC $CFLAGS -I"$DAS_ROOT" -o "$STORE" "$TEST_ROOT/das-store-selftest.c"
"$STORE"
$CC $CFLAGS -I"$DAS_ROOT" -o "$ARGV" "$TEST_ROOT/das-argv-selftest.c"
"$ARGV"
$CC $CFLAGS -I"$DAS_ROOT" -o "$PARSER" "$TEST_ROOT/das-parser-selftest.c"
"$PARSER"
$CC $CFLAGS -o "$MKS6" "$TEST_ROOT/mks6rec.c"
$CC $CFLAGS -o "$MKU9" "$TEST_ROOT/mkutf9.c"

"$DAS_ROOT/das" -A -O "$ASCII" "$TEST_ROOT/dxr-input-equivalence.s"
"$MKU9" "$TEST_ROOT/dxr-input-equivalence.s" "$UTF9SRC"
"$DAS_ROOT/das" -A -O "$UTF9" "$UTF9SRC"
"$MKS6" "$TEST_ROOT/dxr-input-equivalence.s" "$S6SRC"
"$DAS_ROOT/das" -S -O "$S6" "$S6SRC"
cmp "$ASCII" "$UTF9"
cmp "$ASCII" "$S6"
"$DAS_ROOT/dxrcheck" -q "$ASCII"
for oldopt in --ascii --optimize -a -o; do
    if "$DAS_ROOT/das" "$oldopt" -O "$BAD_EXPR" \
            "$TEST_ROOT/dxr-input-equivalence.s" >/dev/null 2>&1; then
        echo "DAS accepted retired option spelling: $oldopt" >&2
        exit 1
    fi
done

"$DAS_ROOT/das" -A -L "$COMMON_LABELS" -O "$COMMON" \
    "$TEST_ROOT/dxr-common.s"
"$DAS_ROOT/dxrcheck" -q "$COMMON"
"$TEST_ROOT/dxr-common-check.py" "$COMMON_LABELS"
"$DAS_ROOT/das" -A -O "$COMMON_BSS" "$TEST_ROOT/dxr-common-bss-only.s"
"$DAS_ROOT/dxrcheck" -q "$COMMON_BSS"

"$DAS_ROOT/das" -B -A -O "$LONG_DECIMAL" \
    "$TEST_ROOT/dxr-long-decimal.s"
"$TEST_ROOT/check-dxr-long-decimal.py" "$LONG_DECIMAL"
"$TEST_ROOT/check-dxr-number-radix.sh" "$TEST_ROOT" "$DAS_ROOT/das"
"$TEST_ROOT/check-dxr-number-radix.sh" "$TEST_ROOT" "$DAS_ROOT/pdp10-dec-none-as"
"$TEST_ROOT/check-dxr-c-comments.sh" "$TEST_ROOT" "$DAS_ROOT/das"
"$TEST_ROOT/check-dxr-c-comments.sh" "$TEST_ROOT" "$DAS_ROOT/pdp10-dec-none-as"

"$DAS_ROOT/pdp10-dec-none-as" -L "$GCC_SYNTAX_LABELS" -O "$GCC_SYNTAX" \
    "$TEST_ROOT/dxr-gcc-syntax-compat.s"
"$TEST_ROOT/dxr-gcc-syntax-compat-check.py" "$GCC_SYNTAX"
grep -q '^runtime_compare_subword_branches_all[[:space:]]' "$GCC_SYNTAX_LABELS"

"$DAS_ROOT/pdp10-dec-none-as" -O "$GCC_KL10_DATA" \
    "$TEST_ROOT/dxr-gcc-kl10-data.s"
"$TEST_ROOT/dxr-gcc-kl10-data-check.py" "$GCC_KL10_DATA"

"$DAS_ROOT/das" -A -O "$GLOBL" "$TEST_ROOT/dxr-globl.s"
"$DAS_ROOT/dxrcheck" -q "$GLOBL"

"$DAS_ROOT/das" -A -O "$EXTENDED_OPS" "$TEST_ROOT/dxr-op-extended.s"
"$TEST_ROOT/dxr-op-extended-check.py" "$EXTENDED_OPS"
if "$DAS_ROOT/das" -B -A -O "$EXTENDED_OPS" "$TEST_ROOT/dxr-op-extended.s" >/dev/null 2>&1; then
    echo "DAS strict base accepted EXTEND/MAP" >&2
    exit 1
fi

"$DAS_ROOT/das" -A -O "$SIMH_EXTRA_OPS" "$TEST_ROOT/dxr-op-simh-extra.s"
"$TEST_ROOT/dxr-op-simh-extra-check.py" "$SIMH_EXTRA_OPS"

"$DAS_ROOT/das" -A -O "$SYMBOL_ASSIGN" "$TEST_ROOT/dxr-symbol-assign.s"
"$TEST_ROOT/dxr-symbol-assign-check.py" "$SYMBOL_ASSIGN"
"$DAS_ROOT/das" -A -O "$ASSIGN_DIRECTIVES" \
    "$TEST_ROOT/dxr-assignment-directives.s"
"$TEST_ROOT/dxr-assignment-directives-check.py" "$ASSIGN_DIRECTIVES"
for badsrc in dxr-bad-space-reloc.s dxr-bad-align-reloc.s \
    dxr-bad-point-field-reloc.s; do
    if "$DAS_ROOT/das" -A -O "$BAD_ASSIGN" "$TEST_ROOT/$badsrc" >/dev/null 2>&1; then
        echo "DAS accepted relocatable assignment directive $badsrc" >&2
        exit 1
    fi
done
if "$DAS_ROOT/das" -A -O "$BAD_ASSIGN" "$TEST_ROOT/dxr-bad-equ-duplicate.s" >/dev/null 2>&1; then
    echo "DAS accepted duplicate .equ" >&2
    exit 1
fi
if "$DAS_ROOT/das" -A -O "$BAD_ASSIGN" "$TEST_ROOT/dxr-bad-set-label.s" >/dev/null 2>&1; then
    echo "DAS allowed .set to redefine a label" >&2
    exit 1
fi

"$DAS_ROOT/das" -A -O "$POINT_DEFAULT" "$TEST_ROOT/dxr-point-default.s"
"$TEST_ROOT/dxr-point-default-check.py" "$POINT_DEFAULT"
"$DAS_ROOT/das" -A -O "$POINT_MINUS1" "$TEST_ROOT/dxr-point-minus1.s"
"$TEST_ROOT/dxr-point-minus1-check.py" "$POINT_MINUS1"
"$DAS_ROOT/das" -A -O "$BYTE_EXPR" "$TEST_ROOT/dxr-byte-expr.s"
"$TEST_ROOT/dxr-byte-expr-check.py" "$BYTE_EXPR"
"$DAS_ROOT/das" -A -O "$ALIGN" "$TEST_ROOT/dxr-align.s"
"$TEST_ROOT/dxr-align-check.py" "$ALIGN"
"$DAS_ROOT/das" -A -L "$BLOCK_EXPR_LABELS" -O "$BLOCK_EXPR" \
    "$TEST_ROOT/dxr-block-expr-v1.s"
"$TEST_ROOT/check-dxr-block-expr-v1.sh" "$BLOCK_EXPR_LABELS"
if "$DAS_ROOT/das" -A -O "$BAD_EXPR" "$TEST_ROOT/dxr-bad-block-digit-v1.s" >/dev/null 2>&1; then
    echo "DAS accepted invalid octal .block digit" >&2
    exit 1
fi
"$DAS_ROOT/das" -A -O "$ORG" "$TEST_ROOT/dxr-org.s"
"$TEST_ROOT/dxr-org-check.py" "$ORG"
"$DAS_ROOT/das" -A -O "$COND" "$TEST_ROOT/dxr-conditional.s"
"$TEST_ROOT/dxr-conditional-check.py" "$COND"
"$DAS_ROOT/das" -A -O "$COND_REPT" "$TEST_ROOT/dxr-conditional-rept.s"
"$TEST_ROOT/dxr-conditional-rept-check.py" "$COND_REPT"
"$TEST_ROOT/check-dxr-conditional-rept-errors.sh" "$TEST_ROOT" "$DAS_ROOT/das"
"$DAS_ROOT/das" -A -F -O "$IRP" "$TEST_ROOT/dxr-irp-irpc-v1.s"
"$TEST_ROOT/dxr-irp-irpc-v1-check.py" "$IRP"
"$TEST_ROOT/check-dxr-irp-irpc-errors-v1.sh" "$DAS_ROOT/das"
"$DAS_ROOT/das" -A -F -O "$JUMP_JRST" "$TEST_ROOT/dxr-jump-jrst-fold-v1.s"
"$TEST_ROOT/dxr-jump-jrst-fold-v1-check.py" "$JUMP_JRST"
BRANCH_BARRIER_PLAIN="$TMPDIR/das-branch-barrier-plain-v1.dxr"
BRANCH_BARRIER_OPT="$TMPDIR/das-branch-barrier-opt-v1.dxr"
"$DAS_ROOT/das" -A -O "$BRANCH_BARRIER_PLAIN" "$TEST_ROOT/dxr-branch-barrier-v1.s"
"$DAS_ROOT/das" -A -F -O "$BRANCH_BARRIER_OPT" "$TEST_ROOT/dxr-branch-barrier-v1.s"
cmp "$BRANCH_BARRIER_PLAIN" "$BRANCH_BARRIER_OPT"
echo "DAS deferred-branch phase-barrier contract passed"
"$DAS_ROOT/das" -A -O "$MACRO" "$TEST_ROOT/dxr-macro-v1.s"
"$TEST_ROOT/dxr-macro-v1-check.py" "$MACRO"
"$DAS_ROOT/das" -A -F -L "$MACRO_LABELS" \
    -O "$MACRO_OPT" "$TEST_ROOT/dxr-macro-opt-label-v1.s"
"$TEST_ROOT/dxr-macro-opt-label-v1-check.py" "$MACRO_OPT" "$MACRO_LABELS"
"$TEST_ROOT/check-dxr-macro-errors-v1.sh" "$TEST_ROOT" "$DAS_ROOT/das"
for badsrc in dxr-bad-conditional.s dxr-bad-conditional-reloc.s; do
    if "$DAS_ROOT/das" -A -O "$BAD_EXPR" "$TEST_ROOT/$badsrc" >/dev/null 2>&1; then
        echo "DAS accepted invalid conditional $badsrc" >&2
        exit 1
    fi
done
for badsrc in dxr-bad-org-backward.s dxr-bad-org-reloc.s; do
    if "$DAS_ROOT/das" -A -O "$BAD_EXPR" "$TEST_ROOT/$badsrc" >/dev/null 2>&1; then
        echo "DAS accepted invalid .org $badsrc" >&2
        exit 1
    fi
done
"$DAS_ROOT/das" -A -O "$BAD_EXPR" "$TEST_ROOT/dxr-warning.s" 2>"$DIAG"
grep -q 'EXPECTED WARNING' "$DIAG"
if "$DAS_ROOT/das" -A -O "$BAD_EXPR" "$TEST_ROOT/dxr-error.s" >/dev/null 2>"$DIAG"; then
    echo "DAS accepted .error directive" >&2
    exit 1
fi
grep -q 'EXPECTED ERROR' "$DIAG"
"$DAS_ROOT/das" -A -O "$EXPR" "$TEST_ROOT/dxr-expressions.s"
"$TEST_ROOT/dxr-expressions-check.py" "$EXPR"
for badsrc in dxr-bad-reloc-mul.s dxr-bad-reloc-bitwise.s dxr-bad-divzero.s; do
    if "$DAS_ROOT/das" -A -O "$BAD_EXPR" "$TEST_ROOT/$badsrc" >/dev/null 2>&1; then
        echo "DAS accepted invalid expression $badsrc" >&2
        exit 1
    fi
done

"$DAS_ROOT/das" -A -O "$LIT_DEDUP" "$TEST_ROOT/dxr-literal-dedup.s"
"$TEST_ROOT/dxr-literal-dedup-check.py" "$LIT_DEDUP"
"$DAS_ROOT/das" -A -O "$NESTED_LIT" "$TEST_ROOT/dxr-nested-literal.s"
"$TEST_ROOT/dxr-nested-literal-check.py" "$NESTED_LIT"
if "$DAS_ROOT/das" -A -O "$BAD_SPACE" "$TEST_ROOT/dxr-bad-space-tail.s" >/dev/null 2>&1; then
    echo "DAS accepted malformed .space operand" >&2
    exit 1
fi


echo "das fast input and DXR equivalence tests passed"
