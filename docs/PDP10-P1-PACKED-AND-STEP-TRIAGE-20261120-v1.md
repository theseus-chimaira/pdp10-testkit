# P1 packed aggregate and simulator-step triage (2026-11-20, v1)

Scope: targeted PDP-6 native KCC noopt / GCC O0 verification only.
Original imported C sources, assertions and registries were not changed.
No full compiler matrix or DAIMOS kernel sweep was executed.

## 20010518-2.c: initial packed aggregate assignment

The original test fails with `__test_exit=1` under both KCC and GCC.
Its early operations are:

    a = &b;
    *a = (a_struct){1,2,3,4};
    memcpy ((void *)a, &(a_struct){1,2,3,4}, sizeof (a_struct));
    memcpy ((void *)a, (void *)&b, sizeof (a_struct));
    a->e.b4 = 'c';

Versioned diagnostic copies under
`$TMPDIR/p10tk-p1-packed-field-diagnostic-20261120-v1`
separated the five original field assertions into distinct exit codes.
Both compilers fail the **first field** (`a->a != 1`) with exit code 11
(octal 013). Further diagnostic copies evaluate that first field
immediately after the initial `*a = ...` assignment and after each
explicit memcpy. Both compilers still report 11 at the earliest check.
Therefore the failure is already present **before either explicit
memcpy call**; calling this a libc memcpy failure is not supported.

A diagnostic with four global volatile observables, examined using
p10run, reports `a->a == 0` for both compilers immediately after initial
assignment, after the first memcpy, after the second memcpy, and after
the nested byte store. This is not a passing substitute for the
original executed assertion.

GCC O0's generated `movstrsi` expansion copies 16 9-bit units using
LDB/DPB and IBP, but the initial copy loads addresses with `MOVEI`
and uses them directly as LDB byte pointers; an apparent word-address
versus byte-pointer mismatch requires a compiler backend fix. KCC
noopt instead emits a packed-field initialization followed by BLT;
its readback also yields zero, so an equivalent GCC-specific mechanism
must not be presumed for KCC. Both compiler paths need independent
targeted RTL/assembler analysis before modifying their backends.

## 920501-2.c: separate execution limits from wrong answers

After fixing KCC installed DImode helper selection, the original test
passes KCC PDP-6 noopt. GCC PDP-6 O0 at 100,000,000 instructions
prints `Step expired`, without reaching the guest termination path.
This is **instruction-budget exhaustion**, not a completed assertion.
When the same original test was rerun with a 600,000,000 instruction
budget and an extended timeout, SIMH instead HALTed with
`__test_exit=1`. This is a **genuine remaining GCC execution
failure**; it cannot be resolved by simply relabeling the 100-million
step failure.

The semantic runner previously classified a step-expired report as
`run_fail` because p10run also reported the still-initialized
`__test_exit=1`. The runner now scans the report line by line and
classifies an incomplete `Step expired, PC:` execution as `timeout`.
An executed failing guest assertion remains `run_fail`; a linker
failure remains `link_fail`. Reports remain available for exact
distinction between wall-clock and instruction-budget exhaustion.

## Additional runner failure-mask correction

The normal KCC semantic runner could overwrite an earlier missing
freestanding libc setup error with a later, successful KCC runtime
fragment lookup. An injected negative regression demonstrated that it
erroneously proceeded to launch p10run. The runner now preserves the
earliest setup error and fails closed. A registered host-only control
verifies this behavior without executing p10run.

## Evidence and remaining work

- Scratch execution: `$TMPDIR/p10tk-p1-packed-field-diagnostic-20261120-v1`
- 600-million-step GCC evidence:
  `$TMPDIR/p10tk-p1-gcc-mod-step-20261120-v1`
- Corrected 100-million-step GCC classification:
  `$TMPDIR/p10tk-p1-gcc-mod-step-classified-20261120-v1`
- Registered regression: `tools/test-runner-result-accounting-v1.py`
- Earlier source and baseline: `docs/PDP10-P1-TARGETED-LIBC-PROBE-20261120-v1.md`

Remaining compiler work: prove and repair the packed-aggregate
initialization paths in GCC and KCC, and independently inspect the
GCC `920501-2.c` arithmetic/ABI result after program termination.
Do not alter original assertions or fabricate runtime implementations.
