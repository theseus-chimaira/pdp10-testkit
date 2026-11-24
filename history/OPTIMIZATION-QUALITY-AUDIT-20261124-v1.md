# Optimization quality audit v1

Tool commit d37eead. Audit archived assembly checkpoints, without
recompiling C. Compare within source, run directory, compiler, machine
and architecture family. Historical run directories may have mixed
compiler revisions; archived results are triage, not current-build proof.

67413 archived assembly cells, 1017 sources, 149 runs. 64053 matching
DOBJ objects; 3328 additional outputs reassembled successfully using
the installed assembler; 32 could not be measured. Measure text,
data and BSS in 36-bit words, not file bytes or assembly line counts.
No peak stack measurement. Successful comparable KCC pairs: 10451
smaller, 12 larger; GCC Os versus O0: 9356 smaller, 11 larger.
358 KCC and 1789 GCC size pairs have unverified correctness.

Replay archived linked images with their original exit oracle and
SIMH show time before and after execution. Simulated ticks are not
calibrated physical CPU time. Same machine and runtime-library hash
required. 35654 GCC archived cells are eligible for speed comparisons.
80 replayed: 20 O1/O0 improved, 13 O2/O1 improved, 7 O2/O1 regressed,
20 Os/O0 improved. Remaining eligible cells not yet replayed.
The 7 O2 regressions are floating conversion v45b, 1-4 extra ticks.

Recompile three size-regression candidates in 14 targeted cells, all
PASS. Installed KCC sha256 ec336dcde92a22311a2dba69d6940daea466a7296d4fc8668aebfef5106c6602.
Staged GCC v48g 2f5a6f5 sha256
2bcceb94d11611d8ad631c7a7cb785a4a7e26a295ebd41d494669d791a4e64b8.
KCC 20001221-1.c PDP6 22->23 words, KS10 19->20;
921019-2.c PDP6 38->41. GCC 20011024-1.c PDP6 Os 49->57 words,
519->556 ticks; KS10 53->57 words, 460->470 ticks. O1 also slower.
All 8 GCC recheck replays passed. These remain optimization work,
not correctness failures.

Reports: workdir/optimization-quality-audit-v1/{cells.tsv,comparisons.tsv,
summary.txt,speed-replay.tsv}; current recheck in
workdir/optimization-size-recheck-audit-v1. Exact exception and speed
measurement manifests retained in git. Resume saved-image speed audit:

    python3 tools/audit-optimization-quality-v1.py --out-dir workdir/optimization-quality-audit-v1 --resume --replay-limit 256 -j 4

Do not claim full speed coverage, cycle accuracy, or current-build
provenance for the historical archive. No full compiler sweep.
