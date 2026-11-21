# P1 Batch 4: reconciled prerequisite evidence (2026-11-20, v1)

This record covers all ten SHA256-frozen Batch 4 originals: **nine C
sources and one KL10 assembly source**. Only targeted PDP-6 KCC noopt
and GCC O0 observations are included, not a full compiler/CPU sweep.
Historical original source/disposition manifests are unchanged.

| Slot | Original source (under tests/) | KCC | GCC | P1 state |
| ---: | --- | --- | --- | --- |
| 1 | semantic/upstream/extensions/builtin-prefetch-6.c | link_fail | PASS | partial |
| 2 | semantic/upstream/extensions/20010518-2.c | run_fail | run_fail | blocked |
| 3 | todo/generic/991112-1.c | link_fail | link_fail | blocked |
| 4 | semantic/upstream/pdp10/pdp10/conversion.c | run_fail | link_fail | blocked |
| 5 | todo/generic/20020412-1.c | compile_fail | run_fail | blocked |
| 6 | todo/generic/920501-8.c | timeout | compile_fail | blocked |
| 7 | todo/generic/920726-1.c | PASS | compile_fail | blocked |
| 8 | semantic/upstream/support/920428-1.s | KL10 ISA harness required | not a C test | blocked |
| 9 | todo/generic/20020406-1.c | timeout | timeout | blocked |
| 10 | todo/generic/920810-1.c | timeout | compile_fail | blocked |

**18 compiler cells:** 2 PASS, 4 `run_fail`, 4 `link_fail`,
4 `compile_fail`, 4 `timeout`. The KL10 assembly fixture remains
unexecuted, not a C compiler success. The older 2026-11-19 snapshot
counted eight `run_fail` cells; four actually exhausted the SIMH
wall timeout without a readable guest result.

## Evidence provenance and gates

`manifests/PDP10-P1-BATCH4-RECONCILED-20261120-v1.tsv` is derived
by `tools/audit-p1-batch4-reconciled-v1.py` from the original frozen
batch assignment, the older Batch 4 probe, and newer source-pinned
libc, variadic and hosted evidence:

- `manifests/PDP10-P1-BATCH4-LIBC-CONTRACT-20261120-v1.tsv` (slots 3-4)
- `manifests/PDP10-P1-BATCH4-VARIADIC-CONTRACT-20261120-v1.tsv` (slots 5-7)
- `manifests/PDP10-P1-BATCH4-HOSTED-CONTRACT-20261120-v1.tsv` (slots 9-10)

Unchanged older outcomes for slots 1, 2 and 8 retain explicit
historical provenance. Slot 2 also has a separately documented
2026-11-20 installed-toolchain rerun. The audit checks all
19 source/profile identities, original file hashes, frozen slot
assignments and the failure-class census. Six host-only negative
controls reject falsified statuses, ISA success, hash changes,
duplicate compiler IDs, invented provenance and omitted records.

Neither the prefetch subset PASS in slot 1 nor the KCC formatting
PASS in slot 7 proves their broader unresolved semantics. The
actual `isprint` and `__fixunssfsi` linker prerequisites remain
separate from confirmed guest failures, missing GCC `stdio.h`,
and SIMH timeouts.

The **Batch 4 prerequisite triage** is complete for these limited
profiles, but source acceptance is not: Batch 4 remains
**0 covered, 1 partial, 9 blocked**; full P1 remains
**38 covered, 1 partial, 28 blocked**. No compiler repairs, test
substitutions, matrix expansion or full sweep were undertaken.
