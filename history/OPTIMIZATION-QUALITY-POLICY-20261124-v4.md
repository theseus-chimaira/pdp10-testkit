# Optimization acceptance policy v2, audit v4

The required comparisons are KCC opt < noopt in total target words;
GCC O1 < O0 in simulated ticks, O2 <= O1 and O2 <= Os in ticks,
and Os < O0 in both total words and ticks. Text size is reported
separately as diagnostic data. Equal times pass only the two O2
comparisons. Missing, incomparable library, or failed correctness
measurements remain unverified, never a pass.

The v2 audit uses the same rules for replay selection and reporting.
It adds acceptance-summary.tsv and acceptance-failures.tsv.
Existing v1 reports and raw measurements are preserved.

Reclassification of the 848 archived speed measurements:
O2 versus O1: 145 faster, 39 equal, 34 slower.
O2 versus Os: 73 faster, 27 equal, 104 slower.
138 failure comparisons, 108 distinct archived O2 configurations,
with 30 overlapping. These are historical triage, not proven current
compiler regressions. The archive-wide speed audit is incomplete.

The 88 v50d-equivalent memory-copy images have 19/22 passing O2/O1
comparisons and 21/22 passing O2/Os comparisons. Four distinct
configurations fail: three KS10 profiles of 20011024-1.c (one tick
slower than O1), and gcc-base PDP6 of the literal-copy regression
(1889 versus 1868 ticks at Os). The saved KS10 Os result for
20011024-1.c is 174 ticks, not the previously reported 173.

Resume with:
    python3 tools/audit-optimization-quality-v2.py --out-dir workdir/optimization-quality-policy-v2 --resume --replay-limit 512 -j 4

No new executable replays or compiler changes in this policy update.
