# Specialized-script ownership audit (2026-11-16 v2)

## Scope and result

The six `misc/` scripts without discovered static callers in the
historical `CROSS-REPO-TEST-CENSUS-20261116-v1.md` were reviewed by
opening their actual source, not by treating filenames as test evidence.
The original filenames in the table are historical identifiers. The
retired DAS single-image checker has no current executable path; it
must not be called in place of the native-phase chain verifier.
Four are deterministic, standalone **host-side** checks and are now
registered in `SPECIAL_TESTS.tsv`. One exploratory probe remains
deliberately unregistered. The sixth was an obsolete single-image DAS
checker and has been retired.

| Original script | Disposition | Evidence and limitation |
| --- | --- | --- |
| `misc/compat/test-aap-timing-trace-v1.py` | Enabled `compat` / host | Exercises valid and malformed/descending timing milestones; checks parser behavior only, not timing accuracy |
| `misc/compat/test-pdp6-opcode-report-v1.py` | Enabled `compat` / host | Exercises the opcode-report parser with synthetic dispatch counters; no PDP-6 CPU execution |
| `misc/compat/test-pdp6-profile-comparison-v1.py` | Enabled `compat` / host | Exercises instruction-count rejection, an explicit tolerance, and unavailable weighted-cost handling; no CPU execution |
| `misc/validation/analyze-aap-pdp6-emnf-case9-v1.py` | Enabled `validation` / host | Reconstructs one fixed DEC FDAS/EMNF case; does not characterize the other 23 arithmetic cases or compare an AAP trace unless a log is supplied |
| `misc/compat/test-aap-illegal-relocation-probe-v1.py` | Exploratory, not registered | Builds an external AAP emulator and probes JRST candidates; its own contract explicitly says this is **not** an ILLOP acceptance test |
| `misc/das/check-das-native-image.py` | Retired | Expected an ASCII-octal monolithic image and old native workspace names; current DAS produces binary DXR driver/DAS1/DAS2 images checked by `check-das-native-phases.py`, `check-das-native-chain.py`, and the full DAIMOS guest |

The two self-tests that previously required a positional reporter or
comparator now default to the matching in-tree tool while preserving
explicit override arguments. Their temporary fixtures use `$TMPDIR`
instead of an implicit system temporary directory. No new alternate
special-suite dispatcher was introduced.

## Verification

Invoked all four scripts directly without positional arguments:

```
AAP timing milestone parser v1: PASS
pdp6 opcode report v1: PASS
pdp6 profile comparison v1: PASS
PASS: DEC FDAS/EMNF case 9 yields 544000000003
```

`python3 tools/audit-test-inventory-v1.py` reports 218 unique
special registrations, 1,984 matrix sources, zero unowned test
sources and **PASS**. The updated read-only census classifies
`misc/` scripts as 197 directly registry-dispatched, 7 nested-owner,
4 manual, 95 referenced but not directly registered, and **1** with
no discovered reference (the exploratory JRST probe). A textual
reference does not establish execution, and nested helpers must not
be counted as separate scheduled invocations.

The original v1 census and its TSV remain historical snapshots of
an earlier set of checkouts and execution routing; their former
`registered-das-aggregate-only` label is not valid after DAS
dispatch moved to ordered registry rows. The census tool now
distinguishes those registered DAS profiles from nested helper rows.
The currently selected `gcc-pdp10` revision lacks a tracked
`gcc/testsuite` tree; the census explicitly marks its zero GCC counts
as unavailable source, not proof of complete compiler-test coverage.

The four new registrations run when selecting the corresponding
`compat` or `validation` special group (including `verify`). A full
`verify` or compiler matrix run was **not** carried out for this audit;
the observations above are four focused host checks and one static
inventory audit, not evidence for other registered tests.
