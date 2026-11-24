# KCC runtime closure v43

The installed cdcadb0-based compiler still failed the six historical
PDP-6 cells. No committed repair branch existed. The uncommitted v38
patch was rebased onto cdcadb0, preserving the intervening initializer
argument-liveness repair. Commit b57fa3e updates the integral 71-bit ABI,
nonnegative enum compatible type and small-magnitude division path.

Staged: six original cells and 169 guard cells PASS (66 new regression
cells and 103 earlier historical cells). Seven existing compatibility
scripts passed: dimode storage, negative mixed-compiler ABI, wide
fixed calls, data layout, integer modes, varargs and char/enum policy.
Installed recheck: six of six PASS, original step budgets unchanged.
Hosted SHA256:
ec336dcde92a22311a2dba69d6940daea466a7296d4fc8668aebfef5106c6602.

No active historical KCC failures remain in the tracked v28 cohort.
The new regressions retain v38 filenames. GCC pending in those rows.
No full sweep, native execution or RAM measurement; independent native
KGEN edits preserved. The prior compiler is backed up locally.
