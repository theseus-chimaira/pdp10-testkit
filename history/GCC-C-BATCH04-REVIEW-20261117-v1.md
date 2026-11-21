# Historical GCC C integration, batch 04 of 50 (2026-11-17 v1)

## Scope and provenance

Batch 04 reviews exactly the next 50 original C sources in the 679-source
non-PDP-10 GCC archive, after the three earlier 50-source batches.
All 50 are from the historical `gcc.dg` tree. The original source
retained snapshots under `refs/gcc-c-unmirrored-v1/gcc.dg/` remain
byte-for-byte unchanged at GCC revision
`b0f5374f6d4462bb8759160ece635e306d90998f`. The 20 inapplicable
original snapshots from this batch were subsequently deleted.
Every source was inspected for the actual DejaGNU oracle, original target
and flags, PDP-10 semantics, KCC compatibility, and same-name overlaps.
The individual classifications, original/derived source hashes, and
unexercised conditions are retained in
`manifests/GCC-C-BATCH04-20261117-v1.tsv`.
The deleted-source list and rejection rationales are recorded in
`manifests/GCC-C-INAPPLICABLE-REMOVALS-20261117-v1.tsv`.

| Decision | Number of original C sources |
| --- | ---: |
| Integrated as pending test sources | **5** |
| Deferred because original check cannot currently be reproduced | 25 |
| Inapplicable with current PDP-10 ISA, ABI and runtime | 20 |
| **Reviewed** | **50** |

This is a **source-level and static-inventory integration only**.
No KCC/GCC compilation, assembler, linker, simulator, or runtime test
was executed. `pending` does not indicate a passing or even compiling
case. No changes were made to the unrelated, already-modified compiler
negative-policy files in the working tree.

## Five registered compile-only tests

All five tests reside under `tests/codegen/gcc-historical-b04-v1/`.
No runtime test was admitted from this batch. Four original compiler
optimizations or diagnostics are explicitly not inferred from a source
file that happens to parse on PDP-10.

| Source | Compiler eligibility | Contract and qualification |
| --- | --- | --- |
| `980502-1.c` | GCC and KCC | C declarator and codegen: a `char *const` local is a const pointer, but its referenced `char` may be assigned; source is **compile-only** because writing a string literal would be undefined if executed |
| `990524-1.c` | GCC and KCC | Compile-only register-pressure/branch-loop source with long local state, indirect external call and nested conditional control flow; do not run because original local values are uninitialized |
| `asm-2.c` | GCC only | GNU *extended* inline assembly template `foo%%bar` must emit the literal text `foo%bar` |
| `asm-3.c` | GCC only | GNU *basic* inline assembly template `foo%%bar` must emit the literal text `foo%%bar` |
| `asm-4.c` | GCC only | GNU named inline-assembly operands and matching input/output constraints must compile; the original `dontdg-final` regexp probes were disabled and are **not** treated as required output |

`asm-2.c` and `asm-3.c` have explicit
`codegen-require-regex` directives that match the original
`scan-assembler` expectations in generated assembly. This preserves
the important *one percent vs. two percent* distinction instead of
counting either source as passing on successful compilation alone.
The regex directives are parsed by the existing codegen runner;
no compiler- or assembler-output result is claimed. The more complex
named-operand syntax and exact percent escaping have not been shown
KCC-equivalent and remain GCC-only. The two portable C-level sources
are shared with KCC; the original ISA-specific i686 optimization
conditions are **not** claimed as cross-compiler failures.

The original DejaGNU GCC flags and target restrictions still appear
in the TSV. The batch-04 compiler matrix enables only **PDP-6 native**
GCC `-O0`, `-O1`, `-O2`, `-Os` for the five sources (20 pending cells),
and **PDP-6 native/base** KCC for the two C-level sources
(four pending KCC cells). Other CPU/profile columns remain `no_test`.
The KCC columns are shared across optimized and `-n` runs, so these
four column entries do not represent four completed executions.

## Why the other 45 cases are not active

**Diagnostic and option oracles.** The batch contains a concentrated
set of `gcc.dg/W*` tests for `-Wconversion`, `-Wlarger-than`,
`-Wparentheses`, `-Wreturn-type`, `-Wshadow`, `-Wswitch`,
`-Wswitch-default`, `-Wswitch-enum`, `-Wunreachable-code`, and
warning-as-error modes. These explicitly require `dg-warning`,
`dg-bogus`, `dg-error`, or warning severity/position matches. Merely
compiling their source bodies would not assert the historical compiler
behavior. They remain deferred until the diagnostic policy can
express their positive and negative expectations separately for GCC
and, where appropriate, KCC. The already-existing, unrelated negative
policy modifications have not been staged or committed.

**C language extensions with combined diagnostics.** `array-2.c`
through `array-6.c` examine GCC extensions for initialized flexible
array members, zero-length arrays, VLA compatibility, and compiler
error/warning placement. Several are intentionally invalid; for
example, `array-5.c` requires specific rejection of nonstatic
flexible member initializers. The original language/diagnostic
contract must be preserved and reviewed independently before
registering these against either compiler. The related GNU empty
aggregate and `-fPIC` cases are deferred, as are the original i686
link-only inline double helpers. `dg-do link` is **not** equivalent
to a generic compile-only matrix entry.

**Foreign ISA and ABI cases.** PowerPC Altivec, ARM constant-pool `ldr`,
Alpha physical registers, x86 `btsl`, `mull`, hard `%esp`, `stdcall`,
x87 `fabs`, PowerPC SDA `stfd`, and Intel floating arithmetic cannot
be emulated by deleting the inline assembly, changing the vector mode,
or ignoring the calling convention. Their original oracles are
inapplicable to the current PDP-10 CPU and KCC/GCC profiles. Cases
where the original test is specifically tied to unsupported optimizer
flags such as `-fPIC`, `-ffast-math`, or `-fno-force-mem` were deferred
rather than registered under an unrelated default option. The large
PowerPC PIC call source `980523-1.c` has only unconditional `exit(0)`
and no effective C-level postcondition; a PDP-10 run would add no
meaningful regression coverage.

Same-name files under existing `tests/semantic/upstream/` or
`tests/codegen/upstream-gcc/` were compared for assertion equivalence,
not assumed equivalent from their basenames. No existing case was
deleted, merged, or reclassified merely because of a name collision.

## Inventory integration and next batch

The static verifier `tools/inventory-gcc-unmirrored-v1.py` now
requires batch 04 to contain **exactly the next 50** unresolved
original source paths, checks the original and adapted SHA256 hashes,
KCC/GCC applicability, and `COMPILER_MATRIX.tsv` eligibility. It
rejects unreviewed CPU/compiler profiles or extra C files in the
batch-04 source directory and keeps the previous three batches and
the 30-source historical KCC eligibility review intact.

After this review, **455** sources still lack assertion-level
decisions: **14** same-name candidates and **441** other unreviewed
original files. Batch 05 should review the next 50 unresolved
sources in ledger order, again recording the native PDP-10 oracle,
compiler-specific diagnostics or assembler patterns, and KCC
applicability separately. No test execution has occurred for batch 04.
