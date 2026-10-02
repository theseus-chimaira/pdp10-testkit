#!/bin/sh
set -eu

: "${TMPDIR:?TMPDIR must be set}"
work=$(mktemp -d "${TMPDIR%/}/p10super-rewrite-v1.XXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

./tests/p10super-rewrite-mk "$work/valid.dobj" valid
./p10super "$work/valid.dobj" >"$work/valid.out" 2>"$work/valid.err"
grep -F 'REWRITE '"$work/valid.dobj"':candidate : SAVE 1; COST=ZERO' \
        "$work/valid.out" >/dev/null
grep -F 'OLD CAIN 5,000000 ; JRST 000002' "$work/valid.out" >/dev/null
grep -F 'NEW JUMPE 5,000002' "$work/valid.out" >/dev/null

./tests/p10super-rewrite-mk "$work/indexed.dobj" indexed-cai
./p10super "$work/indexed.dobj" >"$work/indexed.out" 2>"$work/indexed.err"
if grep -q '^REWRITE ' "$work/indexed.out"; then
        echo 'p10super rewrote indexed CAI as CAI-zero peephole' >&2
        exit 1
fi

./tests/p10super-rewrite-mk "$work/special.dobj" special-jrst
./p10super "$work/special.dobj" >"$work/special.out" 2>"$work/special.err"
if grep -q '^REWRITE ' "$work/special.out"; then
        echo 'p10super rewrote non-plain JRST as ordinary transfer' >&2
        exit 1
fi

./tests/p10super-rewrite-mk "$work/schedule.dobj" schedule
./p10super "$work/schedule.dobj" >"$work/schedule.out" 2>"$work/schedule.err"
grep -F 'REORDER '"$work/schedule.dobj"':left <=> '"$work/schedule.dobj"':right' \
        "$work/schedule.out" >/dev/null
grep -F 'SAVE 0; EXPECTED-FOLD-SAVE 0; EXACT-RUN-POTENTIAL 2 (-0/+0); COST=ZERO' \
        "$work/schedule.out" >/dev/null
grep -F 'A OLD +0 +1 ; NEW +0 +1' "$work/schedule.out" >/dev/null
grep -F 'B OLD +0 +1 ; NEW +1 +0' "$work/schedule.out" >/dev/null
grep -F 'GLOBAL-PLAN: 0/1 CANDIDATES; EXPECTED-FOLD-SAVE-SCORE 0; EXACT-RUN-SCORE 0' \
        "$work/schedule.out" >/dev/null
test "$(grep -c '^  SELECT ' "$work/schedule.out")" -eq 0

./tests/p10super-rewrite-mk "$work/ac-memory.dobj" ac-memory-dependency
./p10super "$work/ac-memory.dobj" >"$work/ac-memory.out" 2>"$work/ac-memory.err"
if grep -q '^REORDER ' "$work/ac-memory.out"; then
        echo 'p10super ignored accumulator-memory dependency' >&2
        exit 1
fi
grep -F 'GLOBAL-PLAN: 0/0 CANDIDATES' "$work/ac-memory.out" >/dev/null

./tests/p10super-rewrite-mk "$work/global.dobj" global-conflict
./p10super "$work/global.dobj" >"$work/global.out" 2>"$work/global.err"
grep -F 'GLOBAL-PLAN: 0/2 CANDIDATES; EXPECTED-FOLD-SAVE-SCORE 0; EXACT-RUN-SCORE 0' \
        "$work/global.out" >/dev/null
test "$(grep -c '^  SELECT ' "$work/global.out")" -eq 0

./tests/p10super-rewrite-mk "$work/schedule-fold.dobj" schedule-fold
./p10super "$work/schedule-fold.dobj" >"$work/schedule-fold.out" \
        2>"$work/schedule-fold.err"
grep -F 'EXPECTED-FOLD-SAVE 4; EXACT-RUN-POTENTIAL 4' \
        "$work/schedule-fold.out" >/dev/null
grep -F 'GLOBAL-PLAN: 1/1 CANDIDATES; EXPECTED-FOLD-SAVE-SCORE 4; EXACT-RUN-SCORE 4' \
        "$work/schedule-fold.out" >/dev/null
test "$(grep -c '^  SELECT ' "$work/schedule-fold.out")" -eq 1

./tests/p10super-rewrite-mk "$work/zero.dobj" zero-form
./p10super "$work/zero.dobj" >"$work/zero.out" 2>"$work/zero.err"
grep -F 'CANON '"$work/zero.dobj"':zero_left <=> '"$work/zero.dobj"':zero_right' \
        "$work/zero.out" >/dev/null
grep -F 'LEGAL=DEPENDENCY-DAG-PLUS-UNLABELLED-ZERO-FORM' \
        "$work/zero.out" >/dev/null
grep -F 'FORM MOVEI-AC-0 -> SETZ-AC' "$work/zero.out" >/dev/null

./tests/p10super-rewrite-mk "$work/rename.dobj" rename
./p10super "$work/rename.dobj" >"$work/rename.out" 2>"$work/rename.err"
grep -F 'RENAME-REWRITE '"$work/rename.dobj"':rename_left <=> '"$work/rename.dobj"':rename_right' \
        "$work/rename.out" >/dev/null
grep -F 'LEGAL=DEPENDENCY-DAG-PLUS-REGION-LOCAL-AC' \
        "$work/rename.out" >/dev/null
grep -F 'RENAME 1->3 2->4' "$work/rename.out" >/dev/null

echo 'p10super source rewrite recommendations: PASS'
