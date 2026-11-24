# Optimization audit continuation v2 and KCC v49

Additional 256 archived GCC executable cells replayed: 336 cumulative.
Archive speed comparisons: O1/O0 85 improved; O2/O1 56 improved,
14 equal, 13 regressed; Os/O0 83 improved. No physical timing claim.
The 8 separately measured current-build GCC cells from v1 remain
separate. The 35654 eligible historical speed cells are not all measured.

KCC v49a (57dbc60) discards an unreachable shared epilogue only when
its private label has no references and the final instruction cannot
fall through. It also retains the lexical return identity before
evaluating the return expression. All 44 original-source profiles
and 169 historical runtime guards pass. 34 of 46 epilogue checks pass;
all 12 failing assembly-policy cells also fail on installed v43.
New semantic regression exercises a tail-only exit and mixed return
paths. No new policy failures. Candidate SHA256:
d7fec94d37471a108c5fa87088738654b2f17a8ddb74318781325c95a84f3cc8.

KCC v49b (edff620) retains a double constant in its existing register
pair for PDP-6 long floating arithmetic rather than folding the pair
into a pseudo-operation requiring two scratch-register pushes and
pops. The profitability check precedes any DMOVN rewrite.
82/82 targeted cells and 169/169 historical guards pass.
All 41 measured optimized/unoptimized pairs are smaller, including
all 22 pairs in the two original regression sources. All 12 historic
KCC size regression configurations are now recovered on the candidate.
PDP-6 20001221-1.c 22 unoptimized, 20 optimized (formerly 23);
KS10 19 -> 17 (formerly 20). PDP-6 921019-2.c 38 -> 34 (formerly 41).
Candidate SHA256:
c62d1f2406d08f96e8ea6f2456daa8e00e02c27b6bb54f6cabd819944ea2a29d.

No new permanent target storage. No full sweep, native RAM measurement,
or installation. Historical GCC size/speed exceptions remain open.
Archive counts are not retroactively changed by current-build repairs.
