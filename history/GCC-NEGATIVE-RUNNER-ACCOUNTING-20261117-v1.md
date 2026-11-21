# GCC 3.2 negative rejection and runner result accounting (2026-11-17 v1)

## Decision on the previously uncommitted work

The four pre-existing uncommitted changes to `SPECIAL_TESTS.tsv`,
`tools/compiler_negative_policy_v1.py`, `tools/run-tests.py`, and
`tools/test-gcc-negative-policy-v1.py` are **useful and retained**.
They close real false-green and incomplete-result conditions in the
PDP-10 compiler test runner. The original proposed changes were
reviewed, corrected, and integrated. No unrelated files were discarded.

The review added one independent, versioned host regression at
`tools/test-runner-result-accounting-v1.py`, registered under the
existing `verify` group in `SPECIAL_TESTS.tsv`. There is still only
one matrix compiler runner (`tools/run-tests.py`) and one dispatcher
for special suites. No duplicate runner or test implementation was
created.

## Negative compiler rejection policy

`tools/compiler_negative_policy_v1.py` now exposes
`check_gcc_rejection(returncode, diagnostics)` alongside the
unchanged KCC-specific diagnostic policy. A negative C test **passes
only when the compiler genuinely rejects source code**.

GCC 3.2 routinely emits source errors as e.g.
`source.c:7: invalid operands to binary !=` instead of today's
`source.c:7: error: ...` format. Requiring the modern `error:` prefix
would incorrectly fail real historical diagnostics. The GCC classifier
therefore requires a source-located error message associated with a
`.c` or `.h` file and a line number, and excludes source-located
warning, note and remark messages.

The following cases cannot pass a negative compiler cell even when
other text resembles a C syntax error:

* Compiler exit 0 (incorrect acceptance), negative process exit or
  shell/launcher status 124 or greater
* Internal compiler errors, crashes, segmentation faults, assertion
  failures, or compiler bug-report diagnostics
* Missing input or executable, missing header, invalid target or GCC
  driver option, permissions/setup failures
* No source-located error diagnostic, only warnings/notes/remarks, or
  a locationless driver error

Compiler codes 125-127 have a distinct **`setup_fail`** result in
`compile_to_asm`; code 124 is `timeout`, and compiler signal exits
are `compiler_ice`. Ordinary rejected source remains `fail` at the
compilation layer, then `pass` only after the negative diagnostic
policy accepts the rejection. A diagnostic-looking compiler failure
cannot bypass the reserved-exit check.

The GCC policy is deliberately conservative: it verifies **genuine
source-level rejection**, not the exact contents of every historical
DejaGNU `dg-error`/`dg-bogus` directive. Matching those annotations
remains a separate diagnostic-oracle enhancement. No positive or
warning-only source was silently promoted to a negative pass.

## Worker, restart, and summary correctness

The previously uncommitted `run-tests.py` changes also fix:

1. **All selected cells must have an accountable result.** `failures.tsv`
   and the final failure count include every nonpassing checkpoint,
   including missing (`not_run`), interrupted (`running`), unknown,
   `setup_fail`, and normal policy/compiler/runtime failures.
2. **Interrupted work must be retried.** `--skip-failures` skips only
   previously completed known failure statuses and already-green
   cells. It never treats an unknown, missing, or running checkpoint
   as safely skippable.
3. **Worker exceptions must be checkpointed.** Both sequential and
   parallel paths use one `run_cell_worker`. An ordinary exception
   writes `WORKER_EXCEPTION` to the cell log and persists `setup_fail`
   before returning to the scheduler, preventing a lost result from
   being counted as success. `KeyboardInterrupt` remains interruptible.
4. **Accurate failure type.** Compiler timeout, launcher failure,
   signal/crash and ordinary source-error failure remain separate,
   including in ordinary semantic/codegen and expected-rejection
   codegen cells. Final summaries no longer duplicate `kind_filter`.

This is restart/result accounting, not an additional compiler feature
or a workaround for a compiler ICE. Existing positive KCC rejection
and runtime semantics are unaffected.

## Verification performed

The following checks were run against the final policy implementation:

| Check | Observed result |
| --- | --- |
| GCC rejection-policy synthetic cases | **31/31 pass** |
| Existing KCC rejection-policy synthetic/CLI cases | **17/17 pass** |
| Host runner-accounting regression | **PASS**: missing/invalid/running checkpoints, failure file, restart/skip policy, exception checkpoint, sequential worker failure, reserved exit code 124-139 and -11, GCC negative-cell policy |
| Real installed PDP-10 GCC 3.2 | **3 genuine negative C tests pass** at `-O0 -march=pdp6` using the actual codegen/negative pipeline |
| Real GCC sequential and parallel | **6/6 real negative compile cells pass**: the same three tests under `jobs=1` and `jobs=2`; all status checkpoints valid and both failure reports empty |
| Source/script ownership verifier | PASS; no disconnected `.py` or `.sh` test script |
| Historical GCC source/registry verifier | PASS; 679 reviewed originals, 560 retained, 119 tombstones unchanged |
| Complete registered `verify` group | **13/13 pass**, including the new GCC and runner test registrations |
| Conditioned-source optimization classification | PASS after classifying two prior batch-01 compiler-conditioned tests as semantic-only |
| Python syntax/whitespace checks | PASS |

The three actual C negatives are:
`20000901-1.c` (incomplete type), `20001228-1.c`
(invalid union operand), and `20010425-1.c` (undeclared identifier),
all under `tests/negative/upstream-gcc/gcc-dg-noncompile/`.
Their original diagnostics are emitted by installed GCC 3.2 and
accepted by the policy; this is not only synthetic parser testing.

The host regression verifies that exit codes 125-127 cannot be
accepted as ordinary source errors, that a failed worker cannot
leave a green or missing checkpoint, and that an interrupted selected
cell appears in the failure report and is retried. The tests use
private directories under `$TMPDIR`, not historical source edits.

### Existing verify-group classification defect also repaired

The first complete `verify` group run passed 12/13 entries. The
remaining failure was **not** caused by the four pending runner
changes: the committed batch-01 source imports
`tests/semantic/gcc-historical-b01-v1/20011115-1.c` and
`tests/semantic/gcc-historical-b01-v1/20020402-2.c` contain genuine
compiler-conditioned preprocessor branches but had never been listed
in `OPTIMIZATION_SEMANTIC_ONLY.tsv`.

The first source selects an optimization/compiler-dependent dead
branch; the second uses PDP-10/KCC-specific symbol renaming to avoid
identifier collisions. Both may be tested for correct semantics,
but they are not direct apples-to-apples KCC/GCC size or performance
comparisons. Two exact source rows with those individual rationales
were therefore added to the semantic-only manifest. No C source,
optimization result, or test status was altered to suppress an audit
failure. The repeat run of the entire registered `verify` group
completed **13 passed, zero failed**. This additional correction
keeps the optimization-comparison audit fail-closed.

## Remaining separate work

These checks establish behavior for the representative sources and
synthetic edge conditions. They are **not** a complete GCC negative
suite execution across all PDP-10 CPU/optimization profiles, nor an
implementation of exact `dg-error`/`dg-warning` text matching for the
broader historical corpus. Compiler ICEs, should they be encountered
in those broader sweeps, remain failures to investigate at highest
priority. No assembler, emulator or guest runtime was required for
this policy/runner audit.
