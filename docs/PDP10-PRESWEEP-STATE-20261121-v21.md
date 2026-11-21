# PDP-10 testkit current gate before full sweep (v21)

Date: 2026-11-21. Supersedes v20 as the **live** testkit state;
retains all prior versioned historical evidence without reclassifying
native compiler failures or importing the same originals twice.

## Live inventory and source-construction state

| Item | Measured |
| --- | ---: |
| Compiler matrix sources | 2,318 |
| Special registrations | 404 |
| Owned scripts | 577 |
| Unowned test sources / unconnected scripts | 0 / 0 |
| Original P1 identities covered / blocked | **56 / 11** |
| Frozen 59-batch positions covered / blocked | **48 / 11** |

The live P1 construction ledgers remain
`PDP10-P1-SEMANTIC-RESOLUTION-20261121-v29.tsv` and
`PDP10-P1-SOURCE-BATCHES-20261121-v28.tsv`. The unchanged GNU
`conversion.c` remains covered by six real PDP-6 guest PASS on KCC
and GCC, with separately authenticated 71-bit libgcc source and
runtime helpers. The former 12-blocker reports remain immutable
historical milestones, not current instructions.

The full CPU/compiler/optimization sweep is **still blocked** until
all eleven outstanding original P1 source obligations are completed.
The upstream imported source classifications (551 active, 67
deferred, 58 removed, one nonportable) have not changed.

## KL10 920428 assembler prerequisite checkpoint

`920428-1.s`, the *unchanged* historical MACRO-10 KL10 original,
remains **blocked**. The independent true DAS/DLINK/P10RUN checks
in `PDP10-P1-920428-KL10-TOOLCHAIN-PREREQS-20261121-v1.md`
demonstrate correct parenthesized `BYTE (9)0`, exact KL10 CPU
directive validation, bytes-identical DAS/MACRO-10 fixture DOBJ,
relocation-based external reference tracking, and rejection of
SIMH `Step expired` as a supposed successful HALT. They do **not**
establish actual execution of the original `DEFINE OWGBP`/`GIW`
expression macros, external `%ONE`, or historical `..main` ABI.
The source still fails at `unknown op DEFINE`, and the syntax port
exhausts the KL10 simulator's step budget rather than terminating.
There is **no** KL10 original-source PASS.

The three independently validated KS10 KCC/GCC ABI v1735 scripts
and the installed DAS host phase-pair v1738 script are now
explicitly registered. The host phase-pair check uses a real
DAIMOS stage1 checkout and fails if it is missing; no substitute
was introduced. The current full script-ownership and special
dispatch audits have zero errors. The DAS host repository has a
local KL10 parser fix `aa74f42` which could not be pushed at this
checkpoint because that repository lacks working GitHub credentials;
the testkit's own prerequisite commit `81bf692` was pushed.

## Native 9/18/36-bit pointer ABI locator

The historical `old.tort.c` import was replaced by the active
freestanding C89 source
`tests/semantic/regression/pdp10-byte-pointer-torture-v1.c`.
It **still fails all six** native PDP-6 KCC/GCC optimization
profiles. The exact native failure IDs are KCC noopt 10 and opt 12,
GCC O0 21, and GCC O1/O2/Os 28. This is not a completed original
P1 source-construction milestone.

The separately added, non-aliasing, real `void *` function-pointer
locator `pdp10-void-pointer-roundtrip-locator-v1.c` isolates the
18-bit `unsigned short *` representation: all four GCC PDP-6
profiles PASS, but both native KCC profiles genuinely `run_fail`
with octal `01002`, identifying **both** pointer identity and value
read failure for the halfword pointer. The 9-bit and 36-bit scalar
pointers pass that same focused test. It must be repaired at the
owning KCC ABI lowering rather than hidden by a word-pointer cast.

Evidence `PDP10-P1-OLD-TORT-VOID-POINTER-20261121-v1.md` pins
two complete normal-matrix sources across six profiles: twelve
exact cells (four real GCC PASS, eight genuine run_fail), 60 raw
status/log/assembly/link-map/SIMH artifacts, and seven negative
controls. Source and compiler SHA256s are required by the offline
validator `tools/test-p1-byte-pointer-void-roundtrip-v1.py`.

## Acceptance boundary

No genuine compiler abort or `run_fail` is recorded as successful.
No historical original was weakened, deleted, renumbered or silently
replaced with a fixture for purposes of the P1 closure ledger.
Do not run the full sweep until the outstanding original sources
have source-authenticated execution or valid construction coverage.

Historical detailed snapshots, including all older source-specific
prerequisite repairs, remain in `PDP10-PRESWEEP-STATE-20261121-v20.md`
and its preceding versions. This v21 file is the current live gate.
