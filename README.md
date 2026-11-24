# PDP-10 compiler, assembler and CPU testkit

## 2026-11-24 v29: reproduce all v28 historical link failures

The complete v28 exact known-error replay ended at 327 PASS and 3,889
raw failures across 4,216 selected cells, with no timeout or ICE.
Its 50 remaining linker failures have been independently rerun as
50/50 fresh `link_fail`, with no old-green skips. The versioned
six-column selection is
`manifests/PDP10-V28-LINKER-FAILURE-CELLS-20261124-v29.tsv`.
Root causes: 22 KCC `alloca` (missing compiler stack builtin),
20 GCC/KCC `puts` (intentional bare-machine I/O boundary), four KCC
unreachable `static inline` definitions retaining a real external
relocation, and four KCC incorrect C99 macro-rescan outputs.
No library placeholder, test oracle change, or linker patch was made;
none of the 50 is claimed fixed. See
`history/PDP10-V28-KNOWN-LINK-FAILURE-TRIAGE-20261124-v29.md`.

## 2026-11-24 v27: KS10 optimized signed byte-pointer loads

GCC now retains exact signed nine-bit and eighteen-bit dereferences
of encoded pointers, rather than replacing them with whole-word
loads based on the pointer container's alignment. Constant `POINT 18`
loads select the correct left/right half. The full byte-pointer test
and a new dedicated v27 test each pass 36/36 GCC profiles under
strict exit policy, using separate independent checkpoint directories.
Ten adjacent regression source groups passed another 392/392 GCC
cells, strict exit policy: 464/464 fresh distinct GCC PASS results
in total, without skipped previous green checkpoints.
See `history/PDP10-KS10-SIGNED-BYTEPTR-LOAD-20261124-v27.md`.

## 2026-11-24 v26: GCC packed parameter field extraction

GCC now lowers 9-bit packed fields of by-value formal struct
parameters into distinct signed/unsigned RTL extracts before
optimization can merge the common containing-word MEM. Late
ADD/MOVE lowering retains exact field width and signedness.
The formerly failing original `gnu-packed-byvalue.c` now passes
44/44 GCC profiles; the new C89 signed/unsigned 3/6/11/20-byte
regression passes 36/36. Combined strict verification: 80/80 PASS.
Eight neighboring GCC source groups additionally passed 312/312
cells under strict policy. The v26 validation total is 392/392
fresh GCC PASS cells, without skipped old green records.
See `history/PDP10-GCC-PACKED-BYVALUE-FIELDS-20261124-v26.md`.

## 2026-11-24 v24/v25: all historical timeout clusters resolved

KCC now keeps 71-bit relational true-edges visible across a buffered
conditional return, and restricts 71-bit multiply scratch registers
to the real volatile AC range so callee-preserved structure pointers
cannot be destroyed by `MUL` result pairs. The two formerly timed-
out KCC sources `20020402-3.c` and `20001203-2.c` pass **22/22**
each; new red-old/green-new KCC regressions v24/v25 also pass
**22/22** each (88/88 strict combined). This resolves the final
22 timeout records from the original 135-timeout snapshot. GCC
packed by-value field semantics remain a separate open defect.
See `history/PDP10-KCC-WIDE-CONDITIONAL-RETURN-20261124-v24.md`
and `history/PDP10-KCC-MULTIPLY-PRESERVED-REGISTER-20261124-v25.md`.
The corrected separate scratch policy also passes 440/440 additional
KCC long-long/DImode regression cells, including all 22 formerly
ICE-producing div/mod cells, under strict exit policy.
The final four-source KCC acceptance was independently repeated:
88/88 PASS with the final rebuilt compiler, giving 528 passing
cells across the two fresh acceptance selections.

## 2026-11-24 v23: packed-argument byte-copy loop termination

The compiler's counted byte-copy expansion now emits one SOJN-style
atomic decrement-and-back-edge instruction. The 27 old simulator
timeouts from `gnu-packed-byvalue.c` have been eliminated, although
all 44 GCC cells now report a separate, still-open packed-by-value
ABI/field-access runtime failure. The permanent C89 termination
regression passes 36/36 GCC cells under strict policy. The historical
135-timeout baseline is now 113 resolved, 22 remaining (KCC).
See `history/PDP10-GCC-PACKED-COPY-LOOP-TIMEOUT-20261124-v23.md`.

## 2026-11-24 v22: extended-integer negation timeout recovery

All 36 previously timed-out GCC profiles of upstream wide-integer
test `950612-1.c` now PASS. The backend no longer branches into a
literal-pool `AOJA` during doubleword negation; it uses direct
conditional high-word correction. A fresh isolated strict run of
five source groups passed 284/284 GCC/KCC cells without skipped
checks. The original timeout baseline is now 86/135 repaired or
invalidated, with 49 unresolved in GCC packed-aggregate and KCC
optimizer sources. See
`history/PDP10-WIDE-INT-NEGATION-TIMEOUT-20261124-v22.md`.

## 2026-11-24 v21: timeout triage, valid source and trampoline stack fix

The 135 previous timeouts were traced to seven source identities.
Sixteen were already fixed by the v20 byte-pointer backend repair.
An upstream postincrement oracle had undefined behavior because
`a[0]` was uninitialized; after initializing it, 66/66 GCC/KCC
matrix cells PASS. GCC's trampoline address rounding also placed
nested-function code outside the stack frame, producing 33 genuine
timeouts; the repaired compact BLT implementation passes all
44 GCC test cells. The wide-integer, packed-aggregate and two KCC
optimizer clusters remain unresolved. See
`history/PDP10-TIMEOUT-TRIAGE-20261124-v21.md`.
The final installed-compiler acceptance run covered four registered
sources: **218/218 GCC/KCC PASS** in isolation, strict exit policy.

## 2026-11-24 v20: short16 reverse pointer and optimizer timeout

The GCC logical S=1 branch now uses typed visible RTL byte-pointer
arithmetic instead of an opaque untyped reverse-IBP search that could
be speculated into native S=16 paths. The 16 recorded simulator
timeouts in `runtime-byte-pointer-diff.c` are eliminated; 33/36 GCC
profiles now PASS, while three KS10 optimized load cases remain
failed. The new v20 short16 regression passes 36/36 and six prior
sources pass 216/216 unchanged. See
`history/PDP10-SHORT16-REVERSE-POINTER-20261124-v20.md`.

## 2026-11-24 v19: indexed constant byte-pointer construction

GCC now preserves the 36-bit P/S selector when adding a register
index to a constant local byte pointer. The `*addsi3` emitter uses
MOVEI+HRLI for this exact case, preserving the single MOVEI for
ordinary word addresses. The new v19 regression passes 36/36 GCC
matrix cells. The broad byte-pointer O1 rerun still reports eight
timeouts and one runtime failure: advancing past the former octal
`0250` failure is not a full pass. See
`history/PDP10-INDEXED-BYTEPTR-REPAIR-20261124-v19.md`.
The v18 short16 and v17 unsigned division test groups were also
rerun against v19: all 180/180 GCC cells passed in isolation.

## 2026-11-24 v18: short16 pointer and byte-pointer correctness

The GCC short16 byte-pointer handling now normalizes generic dynamic
indices and constant symbolic addresses consistently, loads signed
16-bit scalar values at their true width, and preserves the result
register across native/logical pointer adjustment. The new registered
`pdp10-short16-pointer-scaling-v18.c` test passes all 36 GCC cells in
an isolated checkpoint directory. The older comprehensive byte-pointer
test now passes its 9 GCC O0 profiles; 11 optimized run failures and
16 timeouts remain recorded. The common six-bit test uses the signed
`int6` contract and additionally tests GCC's unsigned SIXBIT `char6`.
The four preceding unsigned-division source groups were also rerun
against the updated compiler: 144/144 GCC PASS in isolation.
See `history/PDP10-SHORT16-BYTEPTR-REPAIR-20261124-v18.md`.

## 2026-11-24 v17: unsigned SI division and remainder runtime repair

One GCC backend defect accounted for 108 observed runtime failures:
unsigned 36-bit numerators lost bit 35 in the low accumulator of the
70-bit DIV instruction. Rebuilt GCC now passes all 108 original
division, remainder, and combined div/mod cells. A new C89
constant-divisor test is registered in the matrix and passes all 36
GCC cells. The matrix now has 124,091 scheduled cells; 52,636 have
checkpoints, including 2,927 still-recorded `run_fail` statuses and
four interrupted `running` statuses. No complete-sweep claim.
See `history/PDP10-GCC-UNSIGNED-DIVMOD-RUNTIME-20261124-v17.md`.

## 2026-11-23 v16: interrupted sweep, ICE and CHAR_BIT repairs

The interrupted full sweep was resumed without losing existing PASS
checkpoints. Four `running` plus ten missing cells of the same
struct-return regression now pass (54/54 overall). A clean, correctly
prefixed GCC installation replaced a stale `cc1`: the two recorded O0
signbit compiler ICEs and all 32 explicit nine-bit-`CHAR_BIT`
compilation failures now pass their original guest tests. The current
partial census is 6,978 recorded checkpoints: 2,829 PASS,
3,090 `compile_only`, 1,059 `run_fail`, and no `compiler_ice`,
`compile_fail` or `running` statuses. This is not a completed full
123,576-cell sweep. See
`history/PDP10-FULL-SWEEP-CHECKPOINT-RECOVERY-20261123-v16.md`.

## 2026-11-22 v1817: source-linked DAS relocation identity PASS

The recovered historical v1453 symbol-difference fixtures are now
registered here, their correct compiler/assembler testkit owner.
The host DAS object assembler now rejects differences between distinct
undefined exports or separate relocated sections, while accepting same-
section and identical-external-symbol cancellation. The source-linked
`das-fast` suite passed 13/13. The older native relmap test received a
missing bounded `dsys_writechar` diagnostic mock; the same missing-link
failure occurs against old source. Native DAS1/DAS2 assembly and DXR
link pass, with byte-identical phase source output versus the baseline.
No native guest behavior claim. See
`misc/das/symbol-difference-v1817/README-v1817.md`.


This repository tests GCC and KCC compiler behavior, PDP-6/PDP-10
assembler and linker formats, ABI contracts, optimization and processor
ISA execution. Targets include PDP-6, KA10, KI10 and KS10. It is **not**
the DAIMOS operating-system test suite.

Current repository layout: `manifests/` holds machine-readable TSV/TXT
inputs consumed by testkit audits, `history/` holds referenced historical
reports. The current harness state and remaining execution gate are
maintained in `README.md` and `TODO.md`.
`docs/` has been retired. Superseded unreferenced reports remain in Git
history. Use the protected `run-misc-tests.sh` dispatcher for special
compiler tests and `run-tests.sh` for the restartable compiler matrix.

Twenty-two bounded, ten-entry deferred reviews are recorded in
`history/PDP10-DEFERRED-INTEGRATION-FIRST10-20261118-v8.md`,
`history/PDP10-DEFERRED-INTEGRATION-NEXT10-20261118-v9.md`, and
`history/PDP10-DEFERRED-INTEGRATION-BATCH03-20261118-v10.md`, plus
`history/PDP10-DEFERRED-INTEGRATION-BATCH04-20261118-v11.md` and
`history/PDP10-DEFERRED-INTEGRATION-BATCH05-20261118-v12.md` and
`history/PDP10-DEFERRED-INTEGRATION-BATCH06-20261118-v13.md` and
`history/PDP10-DEFERRED-INTEGRATION-BATCH07-20261118-v14.md` and
`history/PDP10-DEFERRED-INTEGRATION-BATCH08-20261118-v15.md` and
`history/PDP10-DEFERRED-INTEGRATION-BATCH09-20261118-v16.md` and
`history/PDP10-DEFERRED-INTEGRATION-BATCH10-20261118-v17.md` and
`history/PDP10-DEFERRED-INTEGRATION-BATCH11-20261118-v18.md` and
`history/PDP10-DEFERRED-INTEGRATION-BATCH12-20261118-v19.md` and
`history/PDP10-DEFERRED-INTEGRATION-BATCH13-20261118-v20.md` and
`history/PDP10-DEFERRED-INTEGRATION-BATCH14-20261118-v22.md` and
`history/PDP10-DEFERRED-INTEGRATION-BATCH15-20261118-v23.md` and
`history/PDP10-DEFERRED-INTEGRATION-BATCH16-20261118-v24.md` and
`history/PDP10-DEFERRED-INTEGRATION-BATCH17-20261118-v25.md` and
`history/PDP10-DEFERRED-INTEGRATION-BATCH18-20261118-v26.md` and
`history/PDP10-DEFERRED-INTEGRATION-BATCH19-20261118-v27.md` and
`history/PDP10-DEFERRED-INTEGRATION-BATCH20-20261118-v28.md` and
`history/PDP10-DEFERRED-INTEGRATION-BATCH21-20261118-v29.md` and
`history/PDP10-DEFERRED-INTEGRATION-BATCH22-20261118-v30.md`.
The thirteenth connected five GCC original sources, including two
verified 71-bit reference-table shift tests, optimized-only builtin
constant checks, a narrow bitfield-size comparison and four
failing packed-bitfield readback profiles. Five other sources
remain deferred for alignment-oracle, hosted-runtime or native
36/71-bit arithmetic expectations. KCC's `bcp-1.c` internal
compiler error remains documented. No source was edited or deleted.
After the 13 reviews, an additional versioned upstream-source
consolidation eliminated **97 exact duplicate source copies**:
50 involving deferred sources and 47 independently registered
active/active pairs with identical compiler profile vectors.
No distinct assertion or supported compiler profile was lost.
The canonical source and original SHA256/provenance for each pair
are recorded in
`history/UPSTREAM-DUPLICATE-CONSOLIDATION-20261118-v21.md`
and its TSV. All **16 outstanding compiler-specific blockers**
from the retired deferred copies remain open in
`manifests/UPSTREAM-CONSOLIDATED-COMPILER-GATES-20261118-v21.tsv`.
The fourteenth bounded review, after consolidation, connected
six original sources. GCC PDP-6 passes all checked optimization
levels except `built-in-setjmp.c`, which passes O0 and **fails
O1/O2/Os**. The three prefetch smoke tests with no assertions
remain deferred; only the side-effect-asserting `builtin-prefetch-4.c`
was connected. No source was modified or removed in this batch.
The fifteenth review connected six more sources, including
71-bit wide-comparison, GNU nested computed-goto, and complex
arithmetic checks. One line in `cmpdi-1.c` now recognizes the
installed uppercase `__PDP10__` target macro, selecting the
existing independently verified 640-result 71-bit reference
table. GCC passes every tested configuration; KCC passes noopt
but fails optimized. `complex-2.c` has the reverse GCC split:
O0 fails while O1/O2/Os pass. No source was removed.
The sixteenth review connected six more sources, including
KCC/GCC numeric conversions, a negative constant divisor,
complex addition, and a full-size `memcpy`/`memset` regression.
The testkit harness was corrected to select real freestanding
library fragments for direct `JRST memcpy` tail calls as well as
`PUSHJ` calls. GCC O2/Os `memcpy-1.c` now link and pass
without any change to the imported C source; GCC O0 and KCC
still fail and remain recorded as such. The unresolved RH18
relocation overflow in `index-1.c` remains deferred for
assembler/linker repair. No original C source was changed.
The seventeenth review connected seven additional meaningful
native PDP-6 tests: three original memcpy/memset/memcmp
readback regressions, nested variadic and nested function
callback ABI tests, and leading-byte memcpy verification.
The newly selected compiler profiles contain **15 GCC passes
and 13 GCC runtime failures**, plus **six KCC passes and two
KCC runtime failures**. `nestfunc-3.c` remains deferred:
GCC O0/O1/O2 simulator runs timed out without readable status,
while Os reached abort. At that time `old.tort.c` was
deferred for nonportable system assumptions, and `packed-2.c`
still had no checked packing assertion. No C source was
changed during batch 17. The former `old.tort.c` was
subsequently **deleted** and replaced by the native, hosted-I/O-free
`tests/semantic/regression/pdp10-byte-pointer-torture-v1.c`.
All six observed PDP-6 profiles are registered as real compiler
assertion failures, not silently skipped. See
`history/PDP10-P1-NATIVE-BYTEPTR-REPLACEMENT-20261120-v1.md`.
The eighteenth review connected five original test sources
covering GNU 71-bit-capable fourth-argument passing, a
struct-by-value argument after three scalars, block-scope
`extern` resolution of external and internal file-scope
objects, and aligned/native-byte `strcmp` sign comparisons.
GCC PDP-6 passes 19 of the 20 newly registered native profiles;
`strct-1.c` fails only O0. KCC passes `strcmp-1.c` both modes,
and `strct-1.c` noopt, but fails the remaining supported
optimized/scope modes. Five other sources require genuine
conversion or hosted stdio support. No original source was
modified or deleted in batch 18.
The nineteenth review connected nine more tests: the native PDP-10
structure-through-varargs ABI source and eight GNU string builtin
optimization checks. The `strct-varg-1.c` original already had
an `stdarg.h` alternative, selected by `NO_VARARGS`. A five-line,
PDP-10-only preprocessor prefix selects that existing branch:
both KCC modes and all four GCC modes now pass. Its historical v21
SHA256 remains intact as evidence; the v27 provenance audit
requires that removing precisely those five lines reproduces
the original hash and that the current hash matches v27.
The eight GNU string source owners add optimized pass/fail
regressions, including three **link errors** for
`string-opt-16.c` where GCC fails to fold intentionally
unresolved `link_error` calls. `strct-pack-2.c` remains
deferred for lack of an assertion. No source was deleted.
The twentieth review connected ten original assertion-bearing
sources: eight GNU string optimization tests and two original
aligned native `strlen`/`strncmp` coverage sources. Previously
missing ordinary freestanding string library linkage is now
available, and all ten run under GCC. The new profiles contain
**seven GCC passes and 33 runtime aborts**; the alignment
`strncmp-1.c` passes all four GCC modes, whereas `strlen-1.c`
fails all GCC modes but passes KCC both ways. KCC additionally
links neither GNU `__builtin_strpbrk` nor `__builtin_strchr`
in either mode; those unsupported GNU-builtin KCC profiles
remain `no_test`, with observed link failures recorded.
No original C source was changed or removed in batch 20.
The twenty-first review connected nine more tests: GNU field
designated initialization, a 37-bit long-long bitfield,
71-bit signed-comparison boundaries and six variadic-argument
ABI tests. The signed-comparison `tstdi-1.c` guard was fixed
to recognize uppercase `__PDP10__` while preserving all
**36 independently verified original expected values**.
GCC passes all four modes; KCC passes noopt but fails
optimized, now conservatively registered as `fail`.
The two standard `stdarg.h` tests `va-arg-10.c` and
`va-arg-2.c` fail GCC O0 but pass O1/O2/Os; four
legacy `varargs.h` tests abort in all GCC modes.
The hosted `struct-ret-1.c` source remains deferred for
genuine `sprintf`, with no direct assertion of returned
structure fields. No source was deleted.
The twenty-second and final first-review batch connected nine
more original tests: GNU variadic aggregates, old-style and
standard variadic passing, wide-character literals, and GNU
zero-length members. The new 36 native GCC PDP-6 profiles
contain **15 passes and 21 genuine runtime aborts**.
`va-arg-9.c` fails O0 but passes O1/O2/Os; three wide/zero-length
source tests pass all GCC modes. The original Latin-1 `0xC4`
wide-string source fails its array-size assertion without any
source transcoding. The deployed `limits.h` incorrectly
advertises a 64-bit long-long maximum while the compiler also
defines `__LONG_LONG_71BIT__`; `va-arg-8.c` executes
its actual checks, but its width guard must not be interpreted
as proof of a 64-bit PDP-10 ABI. The hosted `va-arg-21.c`
remains deferred for genuine `malloc`/`vprintf` support.
All **surviving canonical original identities have now
received an individual first review**. No source was changed
or deleted in batch 22.
The current inventories are **2,261 matrix sources**,
**551 active / 67 deferred / 58 removed** upstream
tests, and
**293 specialized registrations**, including **18 intentionally
manual tests**. No broad sweep was started.
The current upstream and deferred classification manifests are
`SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v25.tsv` and
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv`; older versions
remain historical snapshots.

## Test ownership

- **`pdp10-testkit`** owns GCC/KCC, DAS/DLINK, p10fold, ABI,
  compiler diagnostics/code generation and processor ISA tests
  that run without booting a DAIMOS guest.
- **`../daimos-testkit`** owns DAIMOS boot, kernel, filesystem,
  device, process, syscall, shell and guest-service tests, plus all
  25 guest-native KCC/DAS/DLINK toolchain integration suites.
- Native guest integration tests are explicitly selected in DAIMOS;
  no native suite enters this repository's normal compiler/CPU matrix.
- Generic AAP/PDP-6 instruction/timing fixtures remain here;
  DAIMOS-specific kernel-coverage inventories and runtime profiles
  belong in `daimos-testkit`.

**Priority policy (2026-11-19):** Complete the 59-source P1 semantic
construction backlog in six fixed work batches of 10/10/10/10/10/9.
Historical source hashes and completed batch positions stay stable.
AAP emulator architecture-correctness, exception/PI/device checks,
opcode-coverage expansion and logical-tick validation are **P3**;
they must not block P1 source admission or independently justified
compiler/ABI test oracles. Existing AAP results remain valid evidence,
but further AAP expansion is deferred until P3. See
`history/PDP10-P1-SOURCE-BATCHES-20261119-v1.md` and `TODO.md`.

The historical 150-file split is recorded in the v3 manifest. The
71-file native re-home and current ownership rules are recorded in
`history/TESTKIT-SCOPE-MIGRATION-20261119-v4.md` and
`manifests/NATIVE-TOOLCHAIN-RETURN-20261119-v4.tsv`.

## Usage

Set `PDP10_PREFIX` to the installed toolchain root (containing `bin/`).
Set `TMPDIR` to a writable scratch area; if unset, prefer `$HOME/tmp`.
Optional source overrides include `KCC_REPO`, `DAS_ROOT`,
`DAIMOS_TESTKIT_REPO`, and `PDP10_TOOLS_REPO`.

```sh
export PDP10_PREFIX="$HOME/cross"
export TMPDIR="${TMPDIR:-$HOME/tmp}"
mkdir -p "$TMPDIR"
./run-tests.sh list
python3 tools/audit-test-inventory-v2.py
python3 tools/test-testkit-boundary-v1.py --require-cross
```

`./run-tests.sh` runs selected compiler, CPU and optimization cells;
its `list`, `list-kcc` and `list-gcc` commands only enumerate tests.
`COMPILER_MATRIX.tsv` defines compiler applicability and expectations.
Use `./run-tests.sh --help` and `history/parallel-cells.md` for selector,
resume, output and timeout controls. A pending entry is not a passing
execution result. Full sweeps are operator-selected.

`SPECIAL_TESTS.tsv` records standalone specialized tests, including
22 deliberately manual roots. The 25 booted native toolchain tests are
registered exclusively in `daimos-testkit`. `./run-misc-tests.sh` is the
special-suite entry point; `verify` runs the broader verify/compatibility
and validation groups, **not** merely a fast static ownership audit.
Use `./run-misc-tests.sh list-manual` to enumerate manual roots without
executing them, or `./run-misc-tests.sh run-id TEST_ID` to execute
exactly one enabled registered test. A manual root additionally requires
`--manual`; nested DAS helpers and suite-prepared tools cannot be
launched by ID. This is explicitly selected execution, not a new
automatic suite. See `history/PDP10-SPECIAL-RUNNER-20261119-v3.md`.
Use the individual Python auditors above for host-only preflight.
For named DAS groups use `das-fast`, `das`, or `das-native`.
The independent PDP10-TOOLS suite is sourced from `../pdp10-tools`;
it is not silently replaced by `DAIMOS/tools/host`.

## Directory ownership

| Location | Purpose |
| --- | --- |
| `tests/semantic/` | Compiler semantic/runtime tests; `upstream/` is individually classified |
| `tests/codegen/` | Compiler assembly/code-generation assertions and reviewed GCC imports |
| `tests/negative/` | Rejection and diagnostic source tests |
| `tests/isa/` | CPU instruction and machine-specific semantics |
| `misc/` | Registered special suites (`kcc-host`, `das`, `compat`, `validation`, `tools`) |
| `refs/` | Reviewed historical source snapshots, not automatically runnable tests |
| `manifests/` | Machine-readable test manifests, ownership ledgers and source provenance |
| `history/` | Retained historical reviews and test evidence |
| `tools/` | Matrix runners and static integrity/ownership audits |
| `tests/todo/generic/` | Retained historical generic candidates; some canonical compiler gates are active matrix tests |

## Current pre-sweep state (2026-11-21)

The active `pdp10-testkit` registrations cover **2,358
compiler-matrix sources**, **413 special registrations** and **593
owned script paths**, with zero unowned test sources and zero
unconnected scripts in the complete current worktree. The v1735
ABI scripts and v1738 DAS phase-pair check are now registered and
pass their real native/installed-tool checks. No full compiler/CPU/
optimization sweep has run
in this preparation stage. The historical upstream classification
retains 551 active, 67 deferred, 58 removed and one nonportable source;
historical import disposition must not be read as present compiler PASS.

The live P1 source-specific construction ledger is
`manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261121-v29.tsv`:
**56 covered, zero partial, 11 blocked**. The frozen 59-source batch
ledger now has 48 covered and 11 blocked; no original is deleted or
renumbered. Eleven recent deferred-source intentions have real,
archived PDP-6 evidence: `930513-1.c` (six native KCC/GCC PASS),
`struct-ret-1.c` (four original GCC PASS with a separate asserting
aggregate-return companion retaining one run failure and two timeouts),
`980605-1.c` (three original PASS and six exact-sized live-stack
companion PASS), `920501-8.c` (six substantive variadic-companion
`run_fail` at `sprintf` exit 41, plus retained original timeout/link
failures), `960521-1.c` (two original SIMH timeouts and six
native bounded shifted-array compiler PASS), and `990628-1.c`
(two original malloc-backed timeouts and six 101-int struct-copy
companion guest PASS), and `941014-2.c` (two genuine compiler-only
stdlib link failures, three native compiler-semantic PASS and three
optimized GCC guest `run_fail` at pointer/integer expression checks).
The new `920810-1.c` compiler companion has six native KCC/GCC
PDP-6 guest PASS using real compiler `memcpy` and `memset`, while its
unchanged original link-fails on missing `malloc`. See
`history/PDP10-P1-941014-VOLATILE-SHORT-CLOSURE-20261120-v1.md` and
`history/PDP10-P1-920810-CHILD-COPY-CLOSURE-20261120-v1.md`.
The new `20020406-1.c` companion has six native KCC/GCC PDP-6 PASS
for its exact recursive DUPFF input/cofactor pointer swap; its
unchanged hosted original still link-fails on compiler `malloc`.
See `history/PDP10-P1-20020406-RECURSIVE-SWAP-CLOSURE-20261120-v1.md`.
The `980707-1.c` space-token companion and independent literal
`strcpy` oracle each had three historical optimized GCC PDP-6
`run_fail`, caused by host `strlen` misreading the two-host-byte
9-bit `STRING_CST` encoding. The owning GCC `builtins.c` was
corrected and `cc1` reinstalled; all four GCC PDP-6 profiles now
PASS both existing tests. A separate high-9-bit constant-string
test has four original GCC `run_fail` ID 1, four corrected GCC
PASS, and two still-failing KCC `run_fail` ID 6 for high octal
`\400`. Real compiler-owned C-locale `isprint`/`isspace` and matching
target `ctype.h` now allow the **unchanged `980707-1.c` original**
to PASS all six PDP-6 profiles. The unchanged `991112-1.c` original
also PASSes six profiles; an independent C-locale classifier oracle
PASSes all 512 nine-bit values plus EOF in each of the six profiles.
See `history/PDP10-P1-991112-C-LOCALE-CLOSURE-20261120-v1.md`,
`history/PDP10-P1-980707-SPACE-TOKEN-CLOSURE-20261120-v1.md` and
`history/PDP10-GCC-STRING9-FOLD-REPAIR-20261120-v1.md`.
The `va-arg-21.c` compiler companion preserves the actual
`va_end(**ap_ptr++)` expression and second `ap_ptr++`. Historical
native KCC noopt/opt reports recorded `run_fail` at ID 4 while four
GCC profiles passed. The KCC owning header now evaluates the argument
exactly once (KCC commit `5fa3510`), and the corrected header was
installed. All six freshly selected PDP-6 companion profiles PASS,
plus both KCC variadic-return regression profiles. The unchanged
original still fails linking on hosted `malloc` or `vprintf`. See
`history/PDP10-P1-VAARG21-VAEND-CLOSURE-20261120-v1.md` and
`history/PDP10-KCC-VAEND-HEADER-REPAIR-20261120-v1.md`.
Completing a test oracle does not make the compiler or unavailable
hosted allocator pass.
The pre-existing noreturn regression is scheduled, but all four
targeted GCC PDP-6 profiles currently link-fail on `__builtin_abort`.
Nine historical compiler ICE/signal source/profile pairs were also
revalidated with the installed native PDP-6 compilers; all nine remain
`compiler_ice`, with source- and report-pinned evidence in
`history/PDP10-COMPILER-ICE-CURRENT-20261120-v1.md`. This targeted
codegen recheck was not a full sweep.

The **unchanged original `conversion.c` now PASSes all six native
PDP-6 KCC/GCC profiles**, including every GCC GNU-only 71-bit cast
assertion. GCC commit `bca60ef` fixes six genuine 71-bit compiler
libgcc entry points; KCC commit `bea2680` fixes the preceding signed
D-format and target-width constant-folding defects. New evidence
authenticates 24 native original/71-bit ABI PASS, 129 raw artifacts
and 17 mutation controls; eight earlier 36-bit conversion suites
also PASS all six profiles (48 additional PASS). Genuine historical
GCC link failures, original aborts and timeouts remain archived, not
rewritten. This closes P1 Batch 4 slot 4. See
`history/PDP10-P1-CONVERSION-FULL-20261121-v1.md` and the prior
`history/PDP10-P1-CONVERSION-KCC-ORIGINAL-20261121-v1.md`.

The next frozen P1 source `920428-1.s` remains blocked on genuine
KL10 MACRO-10 `DEFINE` expansion and runtime semantics. Focused
DAS, DLINK and P10RUN defects have been corrected and authenticated:
MACRO-10 `BYTE (9)0` packs identically to DAS 9-bit fields,
`.DIRECTIVE KL10` is validated, unused externs are no longer
required as link dependencies, and an exhausted KL10 step budget
cannot be misclassified as native PASS. See
`history/PDP10-P1-920428-KL10-TOOLCHAIN-PREREQS-20261121-v1.md`.

The historical `old.tort.c` replacement still fails in all six
PDP-6 compiler profiles; a new **independent, C89 halfword-pointer
`void *` roundtrip locator** passes all four GCC profiles but
genuinely fails KCC noopt and opt with identity/data mask `01002`
(octal). Both sources have 12 pinned native outcomes, 60 raw
artifacts and seven negative controls. P1 is not reclassified;
see `history/PDP10-P1-OLD-TORT-VOID-POINTER-20261121-v1.md`.

The follow-up owning KCC repair `4a61c53` also corrects a register
liveness error when canonicalizing two representation-polymorphic
byte/halfword pointers for equality. The independent multi-argument
C89 halfword-pointer source now PASSes all six PDP-6 profiles,
as does the earlier `void *` roundtrip source. The full pointer
torture now PASSes KCC opt; KCC noopt decimal ID 10 and GCC O0 ID 21,
GCC O1/O2/Os ID 28 remain real compiler failures. Post-fix
evidence: 13 native PASS and five run_fail, 90 SHA256-pinned
artifacts and seven mutation controls. P1 remains blocked at 56/11.
See `history/PDP10-P1-BYTE-POINTER-CANONCMP-20261121-v2.md`.

The final KCC first-call argument-liveness fix `551f406` now
also makes the active large byte-pointer torture pass in **both
native KCC PDP-6 profiles**. A new C89 test reproduces the
initial S=9 indirect call followed by an S=18 indirect call.
All three focused pointer tests PASS all six KCC/GCC profiles,
while the larger replacement still has genuine GCC O0 ID 21
and GCC O1/O2/Os ID 28 failures. The v3 evidence pins 20 actual
PDP-6 guest PASS and four run_fail, 120 raw artifacts and seven
mutation controls. KCC noopt's previous SIMH octal `012` was
**decimal ID 10**, not 12; this is corrected in the v2 notes.
See `history/PDP10-P1-BYTE-POINTER-FIRSTCALL-20261121-v3.md`.

For outstanding work and the **explicit stop point before the full
sweep**, see `TODO.md`. Source-specific historical evidence is retained
in `history/` and source ownership is recorded in `manifests/`.

**Exact historical failure replay (v28):** The runner accepts
`--cell-file PATH`, a TSV with fields `test`, `machine`, `compiler`,
`profile`, `kind`, and `status`. Only actual failing or incomplete
historical cells can be selected; a PASS row, duplicate, unknown or
inactive matrix cell is rejected. The current `COMPILER_MATRIX.tsv`
still owns each cell and its unchanged test oracle. Use a **new**
versioned `--out-dir` to avoid rewriting previous full-sweep
checkpoints. The selection can be reviewed with `--list-only`.
`tools/test-exact-failure-selection-v28.py` validates the parser,
selection identity and fail-closed handling of invalid manifests.

**ICE-focused full harness integration (2026-11-21):** All 67 P1
historical identities now have a compiler/ISA harness owner, including
38 newly registered unchanged C originals, the existing reviewed
byte-pointer replacement and a separate KL10 MACRO-10 source. All
105 original C-to-ISA compiler instruction tests are now dispatched;
two VLA C tests with genuine runtime assertions were reclassified,
restoring 36 formerly omitted semantic profile cells. The full
compiler/CPU/optimization matrix has **123,576 scheduled cells**.
The optional `--exit-policy ice-only` leaves all non-ICE failures
intact in checkpoint reports but makes only compiler ICEs, harness
errors and incomplete/missing cells fatal. `--source-file` supports
explicit, source-validated group selection. The first 175 native
PDP-6 original/ISA observations are SHA256-pinned (125 PASS, 49
ordinary failures, one genuine GCC O0 ICE in `991228-1.c` at line 14,
`instantiate_virtual_regs_1`). The 582 raw artifacts are in
`refs/p10tk-harness-native-observations-20261121-v1.tar.gz`
(SHA256 `4da19df1011d4e86bf6d340cbcc11bb295da73ace3d0b06d159582d35be60fc3`). The
full 123,576-cell execution is **not** claimed. See
`history/PDP10-HARNESS-ICE-FOCUSED-INTEGRATION-20261121-v1.md`.

**Pre-sweep restart acceptance (2026-11-21):** A real GCC PDP-6
negative cell was run, skipped on restart with a green checkpoint,
and skipped with `--skip-failures`. Simulated `running`, invalid and
missing checkpoints each triggered a fresh compiler execution and
restored PASS. Runner accounting, ICE-only classification, ownership,
source-provenance and fixture integrity audits passed. This bounded
acceptance does not constitute a full compiler matrix sweep. The
60 registered dispatcher-only raw `p10run` scripts remain dispatcher-
only (23 KCC, 8 GCC, 29 mixed); the v2 census pins all 69 callers.
See `history/PDP10-HARNESS-RAW-P10RUN-REVIEW-20261121-v2.md`.

**Current normal semantic runner policy:** use only the installed
compiler-owned `libp10c-v2.a` (separately for KCC and GCC), never the
generic/DAIMOS libc. It prepares an isolated `p10run` prefix, preserves
the actual target compiler and canonical libgcc, and invalidates
legacy semantic PASS checkpoints from a different libc provider.
Two real native PDP-6 compiler-library guest PASS and six genuine
original-source missing-hosted-function link failures are verified.
See `history/PDP10-COMPILER-STDLIB-RUNTIME-20261120-v1.md`. The official
registered special dispatcher now also isolates the compiler-owned
stdlib for five compiler guest-test groups, with three selected real
PDP-6 registered checks passing. See
`history/PDP10-COMPILER-STDLIB-SPECIAL-DISPATCH-20261120-v1.md`.
Direct raw script invocations and host/tool-builder exceptions remain
separate from this runtime-policy guarantee.
The two GCC stdio production-formatter compatibility scripts now
explicitly link the installed compiler `libp10c-v2.a` rather than
`$PDP10_PREFIX/lib/libc.a`. Their own raw `p10run` calls now also
use a compiler-only temporary prefix when called directly. Both
formatter archives link correctly to the compiler library, and all
four selected PDP-6 O0 guest assertions pass. See
`history/PDP10-GCC-STDIO-DIRECT-COMPILER-ARCHIVE-20261120-v1.md`.
Under the **previous generic/hosted-libc policy**, the GCC original
`920501-8.c` duplicate-global `vsprintf` diagnostic
is now traced to overlapping real formatter providers: selected
`p10stdio-format-v2.s` and default `lib/libc.a` for hosted `printf`.
The exact three-case linker replay is documented in
`history/PDP10-P1-920501-STDIO-PROVIDER-CLOSURE-20261120-v1.md`.
Correct GCC hosted printf/varargs execution is not established.
The previous KCC original `980707-1.c` duplicate-global `exit` has also been
traced to **two real runtime providers**: the testkit CRT's
`exit`/`abort` and default libc's own entrypoints, pulled by `isspace`.
Five source-pinned links and their unresolved guest termination ABI
are documented in
`history/PDP10-P1-980707-CTYPE-PROVIDER-CLOSURE-20261120-v1.md`.
The exact evidence and negative controls are in the adjacent
`PDP10-P1-930513-ORIGINAL-CLOSURE-20261120-v1.md` and
`PDP10-P1-STRUCTRET-HOSTED-CLOSURE-20261120-v1.md`,
`PDP10-P1-980605-STACK-CLOSURE-20261120-v1.md`, and
`PDP10-P1-920501-MANYARGS-CLOSURE-20261120-v1.md`, and
`PDP10-P1-960521-SHIFTED-ARRAY-CLOSURE-20261120-v1.md`, and
`PDP10-P1-990628-RECORD-COPY-CLOSURE-20261120-v1.md`.
The 21 manual roots are pinned in
`manifests/PDP10-MANUAL-ROOTS-20261121-v2.tsv`; the dispatch regressions
compare exact IDs, groups and paths without executing those manual
tests. Historical admission v1-v6 audits also accept only the three
new source-pinned GCC profiles for `930513-1.c`, preserving all
previously prohibited registrations and negative controls.

## Historical static integration state (2026-11-19 snapshot)

- Compiler matrix: **2,261** sources, including forty-nine substantive
  companions for formerly vacuous or width-dependent upstream tests.
- Special registry: **293 entries** (**269** enabled direct, **18** manual,
  **6** nested). Native boot-backed suite identities: **0**.
- DAIMOS native toolchain registry: **25** explicitly selected roots with
  **71** restored source, wrapper and fixture files.
- The source and ownership checks pass; no native or full compiler sweep
  was run during the transfer.
- The full registered **host-only verify** group subsequently passed
  **21/21** on 2026-11-19 after reconciling two post-classification
  ownership decisions and four differential-helper annotations.  See
  `history/PDP10-HOST-VERIFICATION-20261119-v1.md`.  The separate manual
  sweep remains 13 PASS / six not passing and is not a compiler-matrix
  acceptance claim.
- The 16 original consolidated compiler gates are now **normal matrix**
  cells (38 PDP-6 compiler/optimization profiles), rather than a parallel
  execution suite. All 38 profiles were run through `run-tests.sh`:
  36 still fail and the two KCC PDP-6 profiles of `20011113-1.c`
  pass. The separate mutation/negative-control validation tests both
  source call paths without changing the original C file. Full historical
  failure logs and checked hashes: `history/PDP10-COMPILER-GATES-MATRIX-20261119-v1.md`.
- The current **24/24** registered host-only verification tests pass,
  including P1 deferred-source provenance, DEC floating-point oracle
  evidence coverage and the independent target-width shift-table check.
  The PDP-6 width-shift regression passes all six tested KCC/GCC modes;
  further CPU semantics and open P1 deferred-source obligations remain.
  See `history/PDP10-P1-TEST-CONSTRUCTION-20261119-v1.md`.
- The full **67 x 2** deferred-source baseline is now captured, with
  original source SHA256 identities, exact GCC/KCC result distinctions,
  and 134 archived compiler/guest records. Five independently tested
  companion regressions are now in the normal matrix without promoting
  any vacuous historical source. See
  `history/PDP10-P1-DEFERRED-ROUND2-20261119-v1.md`.
  All 26 new companion PDP-6 cells have archived, checksum-verified results
  in `manifests/PDP10-P1-COMPANION-MATRIX-RESULTS-20261119-v1.tsv`.
- Four more assertion-bearing GNU/packed/bitfield companions are now
  registered in the matrix, with 18 actual PDP-6 executions and
  explicit distinction between failing assertions and SIMH timeouts.
  See `history/PDP10-P1-NONASSERTING-COMPANIONS-20261119-v1.md`.
- GNU prefetch address side effects and independent 36-bit-word/71-bit
  multiplication now have ten more normal PDP-6 matrix executions;
  **14/14** original nonasserting sources have an explicit companion
  coverage classification (eight targeted, six partial) without changing
  or prematurely activating the originals. See
  `history/PDP10-P1-PREFETCH-WIDE-20261119-v1.md`.
- The latest registered host verification sweep is **54/54 PASS**.
  Earlier 24/24 and 27/27 milestones are historical counts, not the
  current verifier inventory. **The historical 67 deferred sources
  are not all actionable P1 work.** The audited source-specific
  resolution v1 separated **8 covered**, **6 partial**, and **53 blocked**.
  The current v7 ledger records **38 covered**, **1 partial**, and
  **28 blocked**: **29 currently actionable P1 obligations**. The
  thirty-eight completed intents no longer count as unfinished test
  construction. The original 67 import entries and their compiler
  failures are preserved. The 59 baseline-open sources are assigned to
  fixed source-hash-pinned batches of **10, 10, 10, 10, 10, and 9**;
  Batch 1 is **10/10 covered for test construction**, with unresolved
  compiler, linker and simulator outcomes retained for P2/P3. See
  `history/PDP10-P1-SOURCE-BATCHES-20261119-v3.md`,
  `history/PDP10-P1-BATCH1-FINAL-20261119-v1.md` and
  `history/PDP10-P1-SEMANTIC-RESOLUTION-20261119-v4.md`.
  Batch 2 is **10/10 complete for P1 construction**, with 30
  additional source/profile executions (26 normal matrix, four
  genuine instrumentation-option special runs), including a
  preserved GCC O0 compiler ICE. Batches 1 and 2 are complete;
  Batch 3 is also **10/10 complete** with 42 actual new PDP-6
  source/profile executions, including the original 1,000-case
  generator, native D-format cube root, exact Karatsuba bodies and
  three original prefetch families. Batch 4 is next. See
  `history/PDP10-P1-BATCH2-FINAL-20261119-v1.md`,
  `history/PDP10-P1-SEMANTIC-RESOLUTION-20261119-v6.md` and
  `history/PDP10-P1-SOURCE-BATCHES-20261119-v5.md`.
  Current evidence and priorities:
  `history/PDP10-P1-BATCH3-FINAL-20261119-v1.md`,
  `history/PDP10-P1-SEMANTIC-RESOLUTION-20261119-v7.md` and
  `history/PDP10-P1-SOURCE-BATCHES-20261119-v6.md`.
- Native 36-bit Linux-style device-number encoding is tested by ten
  independent unsigned/modulo reference values on **all six** PDP-6
  KCC/GCC compiler profiles, without changing the original deferred
  32-bit source; see `history/PDP10-P1-KDEV36-20261119-v1.md`.
- Target-width random arithmetic now has a deterministic **36-case**
  signed/unsigned 9/18/36-bit quotient/remainder oracle. Two KCC
  modes pass; all four GCC profiles reach the same real assertion
  failure. See `history/PDP10-P1-DIVMOD-NATIVE-20261119-v1.md`.
- Signed 52/53-bit field XOR/OR and record-return paths now have
  independently calculated sign-extended expected values with actual
  GCC PDP-6 failures in all four optimization profiles. The original
  64-bit-assumption sources stay deferred. See
  `history/PDP10-P1-BITFIELDS-OPERATIONS-20261119-v1.md`.

## Verified integration state (2026-11-17)

- Compiler matrix: **2,211 sources** with no unowned test sources
  and no duplicated classified upstream source bytes.
- Special registry: **284 entries**, including **234 enabled direct**,
  **44 manual** and **6 nested** registrations.
- Script ownership: **426** registered/delegated Python or shell scripts,
  including the v21 upstream consolidation auditor as a module helper.
- Registered host verification: **20/20 passed** after the documentation
  path audit (no full compiler or OS sweep).
- Cross-repository migration: **127** former DAIMOS compiler/assembler
  identities (99 relocated, 28 deduplicated) and **23** OS test files
  relocated into `daimos-testkit`. Both v3 source manifests match.
- Historical upstream classification: **449 active**, **269 deferred**,
  **55 removed**, and **one** nonportable stress source. Classification
  does not establish that all active tests have executed successfully.

No full GCC/KCC or DAIMOS suite was run as part of the ownership split.
The previously observed compiler failures remain recorded, without
weakening their original assertions, in
`history/PDP10-INITIAL-REGRESSION-SWEEPS-20261117-v1.md` and its failure TSV.

Subsequent focused prerequisite validation (no full matrix sweep) is in
`history/PDP10-SPECIAL-DEFERRED-PREREQUISITES-20261117-v1.md`, including
DAS fast **10/10**, a new installed KCC/GCC freestanding archive and
PDP-6 execution test, targeted KCC-host/compatibility fixes, and
20 pilot cells from the 269-source deferred inventory. The
SHA256-pinned outcomes and remaining gates are in
`manifests/PDP10-DEFERRED-BLOCKER-TRIAGE-20261117-v1.tsv`.
The next **2026-11-18 v2** focused checkpoint is
`history/PDP10-SPECIAL-DEFERRED-PREREQUISITES-20261118-v2.md`: split
KCC-runtime prerequisite migration, 21/24 affected compatibility
scripts passing (three real assertion failures retained), 5/5 KCC
regression scripts passing, and 54 more deferred-source cells from
libc/header batches. Its 269-row source-preserving results ledger is
`manifests/PDP10-DEFERRED-BLOCKER-TRIAGE-20261118-v2.tsv`.
The focused ABI/compiler repair checkpoint is
`history/PDP10-ABI-COMPILER-REGRESSIONS-20261118-v3.md`. KCC's
previously unpreserved DImode scratch ACs are repaired upstream
(`948dd9f`), and the new registered five-target/two-mode regression
passes **10/10** with the operational compiler. The mixed-call
fixture's erroneous octal constant is corrected. GCC's packed
record-array pointer/storage mismatch remains a reproduced compiler
failure, not a silently skipped test.
The `2026-11-18 v4` focused checkpoint is
`history/PDP10-VARARGS-AND-GCC-ICE-20261118-v4.md`. The genuine GCC
variable-sized `va_arg` ICE is repaired in `pdp10-gcc` `66f5a15`;
the installed compiler passes a new 16-cell compile-only regression.
Its original dynamic-aggregate semantic execution still fails and
remains deferred. All 26 historically deferred `varargs-abi` sources
(52 operational PDP-6 cells) are recorded, without activation, in
`manifests/PDP10-DEFERRED-BLOCKER-TRIAGE-20261118-v4.tsv`.
The `2026-11-18 v5` focused compiler repair is in
`history/PDP10-GCC-PACKED-RECORD-BYTEPOINTER-20261118-v5.md`. GCC
`c099c40` corrects nonvolatile explicitly packed nine-bit record
strides and byte-pointer field reads/writes. The previously failing
original test and a new stricter companion pass all 32 staged
CPU/optimization cells **and** all 32 operational installed-toolchain
cells. This does not alter the deferred VLA-copy
runtime blocker or imply a full matrix sweep.
The unresolved VLA block-copy investigation is recorded separately in
`history/PDP10-GCC-VLA-AGGREGATE-COPY-20261118-v6.md`. The original
runtime assertion still fails; scratch-only pointer conversion trials
were insufficient and no compiler/libc change was deployed for them.

## Detailed documentation

- `TODO.md`: **open work**, source classification follow-ups and testkit
  verification priorities. Dated checked-off entries are historical
  milestones, not current registration totals.
- `history/REGISTERED-TEST-PREFLIGHT-20261117-v1.md`: original registration,
  dispatcher and host-check preflight (historical snapshot).
- `history/GCC-C-FINAL105-REVIEW-20261117-v1.md`: completed historical GCC C
  classification; source-level TSVs preserve rejected/deferred decisions.
- `history/GCC-C-INAPPLICABLE-REMOVALS-REVIEW-20261117-v2.md`: original
  source tombstone justification and provenance.
- `history/PDP10-CODEGEN-DECLARED-ORACLES-20261117-v1.md` and
  `history/PDP10-DIAGNOSTIC-KCC-INTEGRATION-20261117-v1.md`: implemented
  compiler oracle policy, distinct from runtime results.
- `history/PDP6-FP-SIMH-FIDELITY-20261021-v1.md`: DEC Type 166 hardware
  evidence and the remaining floating-point characterization work.
- `history/PDP6-AAP-LOGICAL-TICK-OPTIMIZATION-20261015-v1.md`: historical
  processor timing work; DAIMOS-specific kernel coverage is now under
  `../daimos-testkit/tests/validation/`.
- `history/PDP10-HISTORICAL-DOC-PATH-AUDIT-20261117-v1.md`: source-path
  reconciliation, historical-provenance crosswalk and missing-link
  regression policy (125 unchanged original source identities).

Dated integration reports remain evidence of what was checked at the
stated time; the current status of registrations comes from the TSVs
and their audits, **not** from historical counts in those reports.
