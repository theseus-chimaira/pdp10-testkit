#!/bin/sh
set -eu
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT=$(CDPATH= cd -- "$HERE/../.." && pwd)
. "$ROOT/tools/pdp10-env.sh"
pdp10_setup_env
AS="$PDP10_PREFIX/bin/pdp10-dec-none-as"
OUTDIR=${TMPDIR:-/tmp}/pdp10-as-kcc-smoke-$$
mkdir -p "$OUTDIR"
trap 'rm -rf "$OUTDIR"' EXIT
"$AS" --version
"$AS" --start 1000 -o "$OUTDIR/kcc_fp_coverage.o" "$HERE/kcc_fp_coverage.s"
test -s "$OUTDIR/kcc_fp_coverage.o"
test -s "$OUTDIR/kcc_fp_coverage.labels"
grep -q 'deposit' "$OUTDIR/kcc_fp_coverage.o"
"$AS" --start 1000 -I "$HERE" -o "$OUTDIR/include-smoke.o" "$HERE/include-smoke.s"
test -s "$OUTDIR/include-smoke.o"
grep -q 'deposit' "$OUTDIR/include-smoke.o"
echo "pdp10-dec-none-as KCC FP smoke: PASS"
