# P1 Batch 5: installed hosted-runtime prerequisite triage (v1)

Date: 2026-11-20. Ten original frozen Batch 5 C sources were probed
using the installed PDP-6 toolchain at KCC native noopt and GCC native
O0. This is a **20-cell bounded prerequisite probe**, not the full
compiler/CPU matrix. Original imported tests, assertions, installed
headers, compiler/linker binaries and freestanding runtime are unchanged.

## Current installed PDP-6 evidence

| Slot | Original (tests/todo/generic/) | KCC noopt | GCC O0 |
| ---: | --- | --- | --- |
| 1 | `930513-1.c` | PASS | compile_fail |
| 2 | `941014-2.c` | timeout | compile_fail |
| 3 | `960327-1.c` | PASS | compile_fail |
| 4 | `960521-1.c` | timeout | timeout |
| 5 | `980605-1.c` | PASS | compile_fail |
| 6 | `980707-1.c` | link_fail | compile_fail |
| 7 | `980709-1.c` | compile_fail | compile_fail |
| 8 | `990628-1.c` | timeout | timeout |
| 9 | `990826-0.c` | compile_fail | compile_fail |
| 10 | `builtin-noret-1.c` | compile_fail | link_fail |

**20 cells: 3 PASS, 10 compile_fail, 5 timeout, 2 link_fail; no
completed guest assertion failures.** All ten unresolved source
identities and their hashes are preserved. The current machine-
readable ledger is `PDP10-P1-BATCH5-CONTRACT-20261120-v1.tsv`, with
one row per original/compiler pair. Both historical and current P1
resolution remain separate from these new operational observations.

### Executed KCC successes do not imply full coverage

- `930513-1.c`: PASS checks `sprintf` called through a function pointer
  with a floating argument and compares the resulting two-byte string.
- `960327-1.c`: PASS checks a local string modification performed
  through `sprintf` and asserts that its expected byte was stored.
- `980605-1.c`: PASS reaches the original arithmetic check for the
  sum 227, after multiple calls involving double-to-short conversion.
  Its `sprintf` output is *not* asserted; its large unused array is
  not evidence of independently verified stack allocation.

All three programs linked a real `sprintf` symbol in the target map,
HALTed in the PDP-6 simulator and left `__test_exit=0`. However,
their **frozen P1 original obligations remain blocked**, because
this only verifies a single KCC PDP-6 profile and does not satisfy
the outstanding multi-profile acceptance policy. It would be
incorrect to claim that every hosted formatting function is absent.

### Missing target headers and language/ABI failures

GCC compilation of `930513-1.c`, `941014-2.c`, `960327-1.c`, and
`980605-1.c` stops on absent installed target `stdio.h`.
For `980707-1.c`, GCC reports both `stdio.h` and `ctype.h` missing.
For `980709-1.c`, GCC lacks `math.h`; KCC also reports missing
`math.h`. For `990826-0.c`, GCC lacks `stdio.h` and `math.h`, while
KCC lacks `math.h`. These are target header prerequisites: none of
those cells reaches guest math/ctype assertions. No host header was
copied to fabricate target availability.

`builtin-noret-1.c` is an optimization/link contract: it tests
noreturn tail-path elimination, not hosted allocation. KCC noopt
rejects a conflicting `_exit` declaration. GCC O0 links unsuccessfully
because `_eexit` is undefined. The source conditionally excludes this
path under lowercase `__pdp10__`, while the installed GCC predefines
uppercase `__PDP10__`; this difference deserves a compiler/source
preprocessor-policy investigation, not a fake `_eexit` implementation.
Neither noopt nor O0 proves the test's intended optimized elimination.

### Incomplete guest executions and memory requirements

KCC `941014-2.c` times out after successfully linking its allocator
and formatting references. Both compilers time out on `960521-1.c`,
whose default `BLOCK_SIZE=32768` requests **two arrays of at least
32768 36-bit integers**, totaling 65536 words before the program,
stack and allocator overhead. This is already at the nominal 64K-word
PDP-6 bare-metal limit and must not be silently called a compiler
miscompile; a deliberately parameterized, separately justified
memory-contract test would be needed for smaller configurations.
Both `990628-1.c` cells likewise time out after linking the real
selected allocator and `memset` paths. A simulator wall timeout with
`rc=124` and no completed `__test_exit` is **not** `run_fail`.

### Linker global-symbol inconsistency: `980707-1.c`

KCC `980707-1.c` compiles, selects genuine `strcmp` and the string
assembly member, then the installed `dlink` reports:

    dlink: duplicate global: exit

The six generated input objects have **exactly one** `DEF exit` across
their symbol tables according to installed `pdp10-objdump -t`, and the
same object set has an unresolved `isspace` reference. This is a real
linker/assembler contract discrepancy requiring future toolchain
investigation; the testkit does **not** suppress the diagnostic or
replace any member. The evidence checker reproduces the symbol-table
count rather than claiming an absent libc function alone caused the
observed linker error.

## Bounded reproduction and audit

The original two chunks of five sources were run separately, in frozen
slot order. From the testkit root, with `TMPDIR` set:

```sh
python3 tools/probe-deferred-libc-v1.py \
  --source tests/todo/generic/930513-1.c \
  --source tests/todo/generic/941014-2.c \
  --source tests/todo/generic/960327-1.c \
  --source tests/todo/generic/960521-1.c \
  --source tests/todo/generic/980605-1.c \
  --compiler all --outdir "$TMPDIR/p10tk-p1-batch5-firsthalf-20261120-v1"
python3 tools/probe-deferred-libc-v1.py \
  --source tests/todo/generic/980707-1.c \
  --source tests/todo/generic/980709-1.c \
  --source tests/todo/generic/990628-1.c \
  --source tests/todo/generic/990826-0.c \
  --source tests/todo/generic/builtin-noret-1.c \
  --compiler all --outdir "$TMPDIR/p10tk-p1-batch5-secondhalf-20261120-v1"
python3 tools/audit-p1-batch5-contract-v1.py \
  --results "$TMPDIR/p10tk-p1-batch5-firsthalf-20261120-v1/results-v1.tsv" \
  --results "$TMPDIR/p10tk-p1-batch5-secondhalf-20261120-v1/results-v1.tsv"
```

The auditor checks original hashes, fixed Batch 5 order, source- and
profile-specific statuses, preserved blocked P1 states, actual target
header/compiler/linker diagnostics, HALT/exit-value reports, SIMH wall
timeout reports, `sprintf` maps for KCC successes, and the `exit`
definition count in the failed linker inputs. The separate host-only
test includes nine negative mutations so that stale manifests, silent
source promotion and failure-stage conflation fail closed.

**Batch 5 prerequisite triage is now complete for the two targeted
PDP-6 profiles, but source closure is not. All ten Batch 5 original
obligations remain blocked.** Full compiler/CPU sweep is deferred.
