# P1 Batch 6: PDP-6 hosted/runtime prerequisite evidence (v1)

Date: 2026-11-20. All nine **unchanged** original Batch 6 C sources were
probed under installed KCC native PDP-6 noopt and GCC native PDP-6 O0,
using the existing freestanding source selector and SIMH harness.
This is a narrowly scoped prerequisite check, **not a full sweep**.
No compiler, assembler, original source, guest assertion, target
header, production library, or batch assignment was modified.

## Actual results

| Slot | Original under tests/ | KCC noopt | GCC O0 |
| ---: | --- | --- | --- |
| 1 | todo/generic/comp-goto-1.c | compile_fail | timeout |
| 2 | todo/generic/gofast.c | link_fail | compile_fail |
| 3 | semantic/upstream/extensions/old.tort.c | compile_fail | run_fail |
| 4 | todo/generic/pdp10/strct-varg-1b.c | timeout | timeout |
| 5 | semantic/upstream/extensions/stdio-opt-1.c | link_fail | compile_fail |
| 6 | semantic/upstream/extensions/stdio-opt-2.c | link_fail | link_fail |
| 7 | semantic/upstream/extensions/stdio-opt-3.c | compile_fail | compile_fail |
| 8 | todo/generic/generic/struct-ret-1.c | timeout | compile_fail |
| 9 | semantic/upstream/extensions/va-arg-21.c | timeout | compile_fail |

**Eighteen PDP-6 cells:** 8 compile_fail, 4 link_fail, 5 timeout,
1 run_fail, 0 pass. Each result is pinned to its actual source
SHA256 and compiler profile in
`manifests/PDP10-P1-BATCH6-CONTRACT-20261120-v1.tsv`.
The historical prerequisite and v8 P1 resolution manifests remain
unchanged; no observed failure is promoted to a compiler PASS.

## Distinct failure contracts

* **Computed goto / address scaling:** KCC rejects multiple pointer
  arithmetic expressions in `comp-goto-1.c` (four errors). GCC builds
  and links but SIMH times out without guest-exit readback. The source
  allocates memory and uses GNU label addresses plus 36-bit/9-bit
  pointer scaling; no portable pointer or allocator stub is suitable.
* **Gofast floating-point diagnostics:** KCC links all the way to the
  external hosted stream variable `stderr`, which is undefined in
  this bare-metal link. GCC lacks target `stdio.h` at compilation.
  Neither result proves the floating-point assertions.
* **XKL `old.tort.c`:** KCC rejects packed pointer operations and
  expressions (three errors). GCC executes and HALTs with
  `__test_exit=0327` (octal) and `result=FAIL`: a **real failed
  original check**, not a SIMH timeout. Crucially, the source's
  non-TOPS20 *successful end path* is `exit(256)`, whereas our
  generic semantic harness currently requires `__test_exit=0`.
  Its target-aware exit/oracle policy needs independent review.
  This run fails before that intended end path; **do not** treat
  any nonzero status as an expected PASS or activate fake TOPS20.
* **Structure varargs:** Both KCC/GCC `strct-varg-1b.c` executions
  link but time out before the original pair of structure-value
  assertions and integer argument checks have a completed outcome.
  Neither a successful ABI nor a guest assertion failure is proven.
* **Stdio optimization:** GCC `stdio-opt-1.c` and `stdio-opt-3.c`
  lack target `stdio.h`; KCC `stdio-opt-1.c` links to an unresolved
  `stdout` variable, while `stdio-opt-3.c` rejects the prior
  `fprintf` parameter prototype. With no stdio include,
  `stdio-opt-2.c` reaches linking: KCC lacks `__builtin_printf`
  and GCC lacks `putchar`. Its optimization-sensitive source
  contains `#ifdef __OPTIMIZE__`; testing O0 alone cannot validate
  the optimized transformation even after hosted linkage works.
* **Structure return with formatting:** KCC `struct-ret-1.c`
  compiles/links but times out; GCC cannot find `stdio.h`.
  The unchanged source compares two formatted output strings,
  **not** the fields of the returned structure, so a future PASS
  would not automatically validate the full structure-return ABI.
* **Variadic `va_end` side effects:** KCC `va-arg-21.c` compiles
  and links but times out; GCC cannot find target `stdio.h`.
  The original calls real `malloc` and `vprintf` and checks a
  pointer increment and NULL skip; these cannot be validated
  with dummy allocator/stdio functions.

All five timeouts have actual SIMH `rc=124`, `result=FAIL`, no HALT
and no completed `__test_exit`, and are not `run_fail`.
The sole completed runtime failure has `rc=0`, HALT and nonzero
`__test_exit`. The four real dlink failures are preserved by their
exact unresolved symbol names. The compilation failures retain
original target-header and diagnostic text.

## Reproduce and audit

Set `TMPDIR=${TMPDIR:-$HOME/tmp}`. From the testkit root:

```sh
python3 tools/probe-deferred-libc-v1.py \
  --source tests/todo/generic/comp-goto-1.c \
  --source tests/todo/generic/gofast.c \
  --source tests/semantic/upstream/extensions/old.tort.c \
  --source tests/todo/generic/pdp10/strct-varg-1b.c \
  --source tests/semantic/upstream/extensions/stdio-opt-1.c \
  --compiler all --outdir "$TMPDIR/p10tk-p1-batch6-firsthalf-20261120-v1"
python3 tools/probe-deferred-libc-v1.py \
  --source tests/semantic/upstream/extensions/stdio-opt-2.c \
  --source tests/semantic/upstream/extensions/stdio-opt-3.c \
  --source tests/todo/generic/generic/struct-ret-1.c \
  --source tests/semantic/upstream/extensions/va-arg-21.c \
  --compiler all --outdir "$TMPDIR/p10tk-p1-batch6-secondhalf-20261120-v1"
python3 tools/audit-p1-batch6-contract-v1.py \
  --results "$TMPDIR/p10tk-p1-batch6-firsthalf-20261120-v1/results-v1.tsv" \
  --results "$TMPDIR/p10tk-p1-batch6-secondhalf-20261120-v1/results-v1.tsv"
```

The audit verifies original hashes, frozen Batch 6 assignments,
unchanged blocked statuses, source/compiler/profile identities,
exact compiler/linker messages, actual HALT/exit values, and
unfinished SIMH reports. Host-only regression
`tools/test-p1-batch6-contract-v1.py` rejects ten mutations:
status promotion, timeout-to-failed-assertion conversion,
misstated non-TOPS20 completion, fabricated linkage, changed
source SHA, duplicate compiler ID, incorrect profile, missing
source, changed frozen slot and premature P1 closure.

**Batch 6 narrow prerequisite triage is complete. All nine original
sources remain blocked** pending meaningful oracle/target policy and
real runtime readiness. Across Batches 4-6, prerequisite triage
is now complete for the selected PDP-6 profiles, **not** semantic
acceptance or cross-CPU validation. The P1 source closure ledger
remains 38 covered, 1 partial, 28 blocked.
