#!/bin/sh
set -eu

TEST_ROOT=${TEST_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)}
DAS_ROOT=${DAS_ROOT:?set DAS_ROOT to the DAS source tree}
TMPDIR=${TMPDIR:?set TMPDIR to a writable temporary directory}
BASE=$TMPDIR/das-phase-ir-v1-$$
trap 'rm -f "$BASE".*' 0 1 2 3 15

"$DAS_ROOT/das" -A -F -L "$BASE.label.labels" \
    -O "$BASE.label.dxr" "$TEST_ROOT/dxr-optimize-label-xct-v1.s"
"$TEST_ROOT/dxr-optimize-label-xct-v1-check.py" \
    "$BASE.label.dxr" "$BASE.label.labels"

"$DAS_ROOT/das" -A -F -O "$BASE.skip.dxr" \
    "$TEST_ROOT/dxr-optimize-skip-state-v2.s"
"$TEST_ROOT/dxr-optimize-skip-state-v2-check.py" "$BASE.skip.dxr"

"$DAS_ROOT/das" -A -F -O "$BASE.ea.dxr" \
    "$TEST_ROOT/dxr-optimize-ea-audit-v1.s"
"$TEST_ROOT/dxr-optimize-ea-audit-v1-check.py" "$BASE.ea.dxr"

"$DAS_ROOT/das" -A -F -O "$BASE.subi.dxr" \
    "$TEST_ROOT/dxr-optimize-subi-flags-v1.s"
"$TEST_ROOT/dxr-optimize-subi-flags-v1-check.py" "$BASE.subi.dxr"

"$DAS_ROOT/das" -A -F -O "$BASE.cai.dxr" \
    "$TEST_ROOT/dxr-optimize-cai-flags-v1.s"
"$TEST_ROOT/dxr-optimize-cai-flags-v1-check.py" "$BASE.cai.dxr"

"$DAS_ROOT/das" -A -F -O "$BASE.fault.dxr" \
    "$TEST_ROOT/dxr-optimize-fault-order-v1.s"
"$TEST_ROOT/dxr-optimize-fault-order-v1-check.py" "$BASE.fault.dxr"

"$DAS_ROOT/das" -A -F -O "$BASE.push.dxr" \
    "$TEST_ROOT/dxr-optimize-push-fault-v1.s"
"$TEST_ROOT/dxr-optimize-push-fault-v1-check.py" "$BASE.push.dxr"

"$DAS_ROOT/das" -A -F -L "$BASE.macro.labels" \
    -O "$BASE.macro.dxr" "$TEST_ROOT/dxr-macro-opt-label-v1.s"
"$TEST_ROOT/dxr-macro-opt-label-v1-check.py" \
    "$BASE.macro.dxr" "$BASE.macro.labels"

echo "DAS private phase-stream optimizer audit gate passed"
