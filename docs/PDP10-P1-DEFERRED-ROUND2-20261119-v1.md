# PDP10 P1: full deferred-source baseline and substantive companion tests (2026-11-19 v1)

## Purpose and provenance

All **67** originally deferred semantic source identities were rechecked
using the installed native PDP-6 KCC unoptimized and GCC O0 toolchains.
The original source checksums come from
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv`; source and
classification ownership remain in
`SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v25.tsv`. No historical
source bytes or expectations were changed, and none of the original
67 deferred sources was automatically activated.

Full outcomes, including each current source SHA256, original blocker,
and remaining action: `PDP10-P1-DEFERRED-PDP6-EVIDENCE-20261119-v1.tsv`.
The corresponding **134 original compiler/linker/guest log records**
are preserved in `refs/pdp10-p1-deferred-pdp6-evidence-20261119-v1.tar.gz`.
`tools/verify-p1-deferred-baseline-v1.py` checks the exact source set,
original source hashes, per-profile result metadata, archived log
hashes and absence of unreviewed promotions; two deliberate metadata
corruptions were rejected.

| Observed result | GCC O0 | KCC noopt |
| --- | ---: | ---: |
| Runtime failure | 28 | 18 |
| Compilation failure | 16 | 25 |
| Link failure | 5 | 13 |
| Internal compiler error | 1 | 0 |
| Successful completion | 16 | 10 |
| Assembler harness required | 1 | 1 |
| **Original identities** | **67** | **67** |

These counts describe **execution**, not passing assertion coverage.
Some nominal passes exit without checking anything, and the original
`20020108-1.c` has a dead 8/16/32-bit shift guard on a 9-bit-char
PDP-10 target. Its independent 9/18/36-bit companion was introduced
and tested separately in the preceding P1 work.

The assembler-only `tests/semantic/upstream/support/920428-1.s`
contains KL10-specific assembly directives and instructions. Its
initial attempts to feed the source into a PDP-6 C compiler have no
valid compiler-test meaning; the probe now records
`assembler-harness-required` rather than a bogus C compilation
failure. A real KL10 DAS/assembler test remains P1 work.

## New assertion-bearing compiler matrix sources

Five **new, versioned C sources** turn previously vacuous upstream
examples or width-dependent assertions into substantive runnable
regressions. The original examples stay deferred; these are companion
tests with a distinct matrix identity, not a silent source alteration.

All 26 compiler-matrix execution records (14 PASS and 12 genuine
runtime failures) are pinned by
`PDP10-P1-COMPANION-MATRIX-RESULTS-20261119-v1.tsv` and archived in
`refs/pdp10-p1-companions-pdp6-20261119-v1.tar.gz`. The registered
`tools/verify-p1-companion-matrix-v1.py` checks original source bytes,
profile sets, status consistency, log checksums and the nonzero failing
assertion checkpoints. Two deliberate metadata corruptions were rejected.

| Standalone companion | Compiler/model | Current PDP-6 observation |
| --- | --- | --- |
| `pdp10-loop-sum-readback-v1.c` | KCC opt/noopt, GCC O0/O1/O2/Os | **6 PASS** |
| `pdp10-aligned-typedef-v1.c` | GCC O0/O1/O2/Os | **4 PASS**; KCC typedef attribute unsupported |
| `pdp10-packed-field-readback-v1.c` | KCC opt/noopt; GCC all four | **2 PASS KCC, 4 run_fail GCC**, GCC fail_id 3 at O0, 1 at O1/O2/Os |
| `pdp10-packed-pointer-array-v1.c` | KCC opt/noopt; GCC all four | **2 PASS KCC, 4 run_fail GCC**, gcc fail_id 1 |
| `pdp10-signed-bitfields-52-53-v1.c` | GCC O0/O1/O2/Os | **4 run_fail GCC**, gcc fail_id 2; KCC wide long-long bitfields unsupported |

The loop-sum companion actually calls the previously uncalled
`inst-check.c` function with seven independent integer expectations,
including 37 -> 666 and 1000 -> 499500. The alignment companion
checks `offsetof` against 16 addressable characters and the resulting
structure size; the original `align-1.c` checked an unrelated
structure size. The packed-member and packed pointer-array companions
check assignments **and readbacks** through the original GNU packed
and aligned declarations. Their numbered failure checkpoints identify
the precise failing assertion under GCC, rather than treating a
successful zero store as proof of correct packing.

The bitfield companion tests signed 52/53-bit minimum, maximum and
negative values independently of the original fixed 64-bit
sign-extension constants and the original `sizeof(long long)==8`
guard. It uses explicit decimal reference values, and both layout
orders to exercise the field decoding. KCC rejects long-long
bitfields at compile time; this is recorded as unsupported, not
accepted as an unrelated compiler bug. GCC's failing readback remains
a compiler regression for future investigation.

All the new sources have normal compiler-matrix registrations. Their
original upstream sources remain pinned to their historic dispositions.
No fake allocator, math routine, stdio implementation or GNU builtin
handler was supplied to force a success.

## P1 still open

The 67 original deferred sources still require source-specific
runtime/ABI prerequisites or valid original test dispositions;
**none have been falsely promoted**. Missing hosted libc/stdio and
allocation support is real work, distinct from compiler fixes. The
original long-long/varargs, GNU builtins and geometry test semantics
need independent target-specific expectations where the historical
oracle assumes 8-bit bytes or 64-bit integers. The KL10 assembler
harness and other CPU-family executions remain to be constructed.

The earlier sixteen canonical compiler gates remain entirely in the
normal matrix with all 38 PDP-6 outcomes preserved; compiler repair
is deferred until testkit construction is complete. Performance
benchmarks and optimization are lower-priority P2/P3 work.
