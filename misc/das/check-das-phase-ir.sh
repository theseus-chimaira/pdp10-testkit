#!/bin/sh
set -eu

TEST_ROOT=${TEST_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)}
DAS_ROOT=${DAS_ROOT:?set DAS_ROOT to the DAS source tree}
TMPDIR=${TMPDIR:?set TMPDIR to a writable temporary directory}
BASE=$TMPDIR/das-phase-ir-$$
trap 'rm -f "$BASE".*' 0 1 2 3 15

"$DAS_ROOT/das" -A -F -L "$BASE.label.labels" \
    -O "$BASE.label.dxr" "$TEST_ROOT/dxr-optimize-label-xct.s"
"$TEST_ROOT/dxr-optimize-label-xct-check.py" \
    "$BASE.label.dxr" "$BASE.label.labels"

"$DAS_ROOT/das" -A -F -O "$BASE.skip.dxr" \
    "$TEST_ROOT/dxr-optimize-skip-state.s"
"$TEST_ROOT/dxr-optimize-skip-state-check.py" "$BASE.skip.dxr"

"$DAS_ROOT/das" -A -F -O "$BASE.ea.dxr" \
    "$TEST_ROOT/dxr-optimize-ea-audit.s"
"$TEST_ROOT/dxr-optimize-ea-audit-check.py" "$BASE.ea.dxr"

"$DAS_ROOT/das" -A -F -O "$BASE.subi.dxr" \
    "$TEST_ROOT/dxr-optimize-subi-flags.s"
"$TEST_ROOT/dxr-optimize-subi-flags-check.py" "$BASE.subi.dxr"

"$DAS_ROOT/das" -A -F -O "$BASE.cai.dxr" \
    "$TEST_ROOT/dxr-optimize-cai-flags.s"
"$TEST_ROOT/dxr-optimize-cai-flags-check.py" "$BASE.cai.dxr"

"$DAS_ROOT/das" -A -F -O "$BASE.fault.dxr" \
    "$TEST_ROOT/dxr-optimize-fault-order.s"
"$TEST_ROOT/dxr-optimize-fault-order-check.py" "$BASE.fault.dxr"

"$DAS_ROOT/das" -A -F -O "$BASE.push.dxr" \
    "$TEST_ROOT/dxr-optimize-push-fault.s"
"$TEST_ROOT/dxr-optimize-push-fault-check.py" "$BASE.push.dxr"

"$DAS_ROOT/das" -A -F -L "$BASE.macro.labels" \
    -O "$BASE.macro.dxr" "$TEST_ROOT/dxr-macro-opt-label.s"
"$TEST_ROOT/dxr-macro-opt-label-check.py" \
    "$BASE.macro.dxr" "$BASE.macro.labels"

echo "DAS private phase-stream optimizer audit gate passed"
