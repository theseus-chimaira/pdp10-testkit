#!/bin/sh
set -eu

: "${TMPDIR:?TMPDIR must be set}"
work=$(mktemp -d "${TMPDIR%/}/p10fold-link-v1.XXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work/tests"
cd "$work"

mk=${P10FOLD_LINK_MK:?P10FOLD_LINK_MK must be set}
p10fold=${P10FOLD:?P10FOLD must be set}
dlink=${DLINK:?DLINK must be set}

# Same-object exact folding and donor/anchor accounting.
"$mk" same tests/same.dobj
"$p10fold" -m 4 -P tests/same.plan tests/same.dobj >tests/same.out
grep -F 'ZERO-COST NON-OVERLAPPING TOTAL: 1 GROUPS; 4 WORDS SAVED' \
        tests/same.out >/dev/null
test "$(grep -c '^FOLD' tests/same.plan)" -eq 1
"$dlink" --fold-plan tests/same.plan -o tests/same.dxr tests/same.dobj
"$mk" check tests/same.dxr 4 4

# Cross-object exact folding.
"$mk" cross tests/cross-a.dobj
"$mk" cross tests/cross-b.dobj
"$p10fold" -m 4 -P tests/cross.plan \
        tests/cross-a.dobj tests/cross-b.dobj >tests/cross.out
grep -F 'ZERO-COST NON-OVERLAPPING TOTAL: 1 GROUPS; 4 WORDS SAVED' \
        tests/cross.out >/dev/null
test "$(grep -c '^FOLD' tests/cross.plan)" -eq 1
"$dlink" --fold-plan tests/cross.plan -o tests/cross.dxr \
        tests/cross-a.dobj tests/cross-b.dobj
"$mk" check tests/cross.dxr 4 4

# A skip immediately before a terminal JRST keeps a live fall-through edge.
# The two four-word prefixes below are identical, but their skip continuations
# differ; folding them would redirect one continuation into the other.
"$mk" skip-tail tests/skip-tail.dobj
"$p10fold" -m 4 -P tests/skip-tail.plan \
        tests/skip-tail.dobj >tests/skip-tail.out
test "$(grep -c '^FOLD' tests/skip-tail.plan || true)" -eq 0

# A skip two words before a candidate block can skip the apparent terminating
# JRST immediately before it and enter the candidate directly.  Since that
# implicit entry has no relocation, p10fold must never remove the block.
"$mk" skip-entry tests/skip-entry.dobj
"$p10fold" -m 4 -P tests/skip-entry.plan \
        tests/skip-entry.dobj >tests/skip-entry.out
test "$(grep -c '^FOLD' tests/skip-entry.plan || true)" -eq 0

# A direct cross-object plan exercises independent LH18/RH18 relocation
# retargeting and movement of a symbol following removed donor TEXT.
"$mk" reloc-anchor tests/reloc-a.dobj
"$mk" reloc-donor tests/reloc-b.dobj
cat >tests/reloc.plan <<'EOF_PLAN'
P10FOLD1
FOLD	tests/reloc-b.dobj	1	tests/reloc-a.dobj	0	4
EOF_PLAN
"$dlink" --fold-plan tests/reloc.plan -M tests/reloc.map \
        -o tests/reloc.dxr tests/reloc-a.dobj tests/reloc-b.dobj
"$mk" check-reloc tests/reloc.dxr
grep -E '^after_fold[[:space:]]+000007$' tests/reloc.map >/dev/null

# A stale plan must not silently delete changed code.
cat >tests/stale.plan <<'EOF_PLAN'
P10FOLD1
FOLD	tests/reloc-b.dobj	1	tests/reloc-a.dobj	1	4
EOF_PLAN
if "$dlink" --fold-plan tests/stale.plan -o tests/stale.dxr \
        tests/reloc-a.dobj tests/reloc-b.dobj >tests/stale.out 2>&1; then
        echo 'dlink accepted stale fold plan' >&2
        exit 1
fi
grep -F 'stale or invalid fold plan range' tests/stale.out >/dev/null

# Duplicate/overlapping donor ranges are invalid even when each fold is exact.
cat >tests/overlap.plan <<'EOF_PLAN'
P10FOLD1
FOLD	tests/reloc-b.dobj	1	tests/reloc-a.dobj	0	4
FOLD	tests/reloc-b.dobj	1	tests/reloc-a.dobj	0	4
EOF_PLAN
if "$dlink" --fold-plan tests/overlap.plan -o tests/overlap.dxr \
        tests/reloc-a.dobj tests/reloc-b.dobj >tests/overlap.out 2>&1; then
        echo 'dlink accepted overlapping fold donors' >&2
        exit 1
fi
grep -F 'overlapping fold donors' tests/overlap.out >/dev/null

# Cross-domain analysis keeps anchor objects read-only.  A named donor may
# pay the one-JRST cost only when its enclosing function is explicitly cold;
# zero-cost isolated donors remain eligible without an allowlist entry.
"$mk" xanchor tests/xanchor.dobj
"$mk" xdonor tests/xdonor.dobj
cat >tests/cold.list <<'EOF_COLD'
# Explicit policy: unlisted functions are not eligible for an added JRST.
cold_fn
EOF_COLD
"$p10fold" -m 4 -a tests/xanchor.dobj -C tests/cold.list \
        tests/xdonor.dobj >tests/xcross.out
grep -F 'JRST-COLD tests/xdonor.dobj+000000 -> tests/xanchor.dobj+000000 : 4 WORDS; SAVE=3; COLD=cold_fn' \
        tests/xcross.out >/dev/null
if grep -F 'JRST-COLD tests/xdonor.dobj+000004' tests/xcross.out >/dev/null; then
        echo 'p10fold allowed unlisted hot_fn one-JRST fold' >&2
        exit 1
fi
grep -F 'ZERO tests/xdonor.dobj+000011 -> tests/xanchor.dobj+000010 : SAVE=4' \
        tests/xcross.out >/dev/null
grep -F 'CROSS-DOMAIN TOTAL: 2 FOLDS; 7 WORDS PROJECTED PERMANENT SAVING' \
        tests/xcross.out >/dev/null
grep -E 'POLICY REJECTIONS: [1-9][0-9]* ONE-JRST SUBRUNS NOT ON COLD LIST' \
        tests/xcross.out >/dev/null
grep -F 'ANALYSIS ONLY: NO CROSS-DOMAIN FOLD PLAN IS EMITTED.' \
        tests/xcross.out >/dev/null

# If the existing anchor-domain fold plan removes an anchor range, that range
# must not be counted as a usable external anchor.
cat >tests/xanchor.fold <<'EOF_XFOLD'
P10FOLD1
FOLD	/example/absolute/path/xanchor.dobj	10	/example/absolute/path/xanchor.dobj	0	4
EOF_XFOLD
"$p10fold" -m 4 -a tests/xanchor.dobj -x tests/xanchor.fold \
        -C tests/cold.list tests/xdonor.dobj >tests/xcross-removed.out
grep -F 'CROSS-DOMAIN TOTAL: 1 FOLDS; 3 WORDS PROJECTED PERMANENT SAVING' \
        tests/xcross-removed.out >/dev/null

echo 'p10fold/dlink exact fold contract: PASS'
