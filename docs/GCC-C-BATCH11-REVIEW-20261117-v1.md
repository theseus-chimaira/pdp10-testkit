# Historical GCC C integration, batch 11 of 50 (2026-11-17 v1)

## Source scope and original assertions

Batch 11 reviews exactly the next **50 unresolved original C sources**
from the immutable 679-source GCC census. All 50 belong to
`gcc/testsuite/gcc.dg/format/` at pinned historical GCC revision
`b0f5374f6d4462bb8759160ece635e306d90998f`. They test the C
front end's **compile-time format diagnostics**, including diagnostic
suppression, GNU attributes, and format behavior under explicit
ISO C90, C94, C99, GNU89, or GNU99 compiler dialects.

The per-original decision ledger
`docs/GCC-C-BATCH11-20261117-v1.tsv` contains 50 records in source
order, with exact original path and SHA256, the individual assertion,
original `dg-do` and `dg-options`, counts of required warnings, errors,
forbidden diagnostics, the preserved `format.h` dependency, separate
PDP-10/GCC and KCC considerations, and the remaining harness
requirements. **There is no claim that compiler tests have passed.**

| Disposition | Sources |
| --- | ---: |
| Deferred, original diagnostic oracle preserved | **50** |
| Newly registered pending | 0 |
| Inapplicable, deleted | 0 |
| **Reviewed** | **50** |

### Diagnostic census

Original DejaGNU annotations in the 50 sources contain exactly:

| Source-level diagnostic assertion | Count |
| --- | ---: |
| `dg-warning` (required diagnostic) | **940** |
| `dg-error` (required rejection/error) | **33** |
| `dg-bogus` (forbidden diagnostic) | **11** |
| Sources without an explicit diagnostic annotation | **5** |

The five annotation-free cases are *not* generic successful-compilation
tests: `c94-printf-1.c`, `c94-scanf-1.c`, `ext-4.c`,
`no-exargs-1.c`, and `no-y2k-1.c`. They deliberately demand
**zero warnings in selected compiler dialects or under particular
warning-suppression options**. Registering them without those flags
and an absence-of-diagnostic checker would remove their only oracle.

The original `format.h` is required by **48 of 50** reviewed sources.
Its archive remains in `refs/gcc-c-unmirrored-v1/gcc.dg/format/`,
and the existing SHA256-pinned companion inventory is unchanged. The
two exceptions, `attr-5.c` and `attr-6.c`, deliberately **do not
include** the header because they test built-in or implicit format
attributes in the absence of usual declarations. Injecting the header
would fundamentally change those tests. No synthetic header was
created and no archived source or include companion was deleted.

## Why all 50 remain deferred

These are genuine GCC format-analysis regressions, and the testkit
must not discard the exact warning/error/absence checks to inflate
compiler coverage. The 50 individual TSV rows preserve the relevant
original source behavior and compiler options. Major sets include:

* **Format attributes:** `attr-1.c`, `attr-3.c` through `attr-7.c`,
  `miss-1.c`, `miss-2.c`, and `multattr-1.c` through `multattr-3.c`
  check attribute syntax rejection, implicit declarations, function
  pointers, multiple attributes, missing-attribute warnings and
  forbidden spurious warnings. Many source lines deliberately generate
  compiler errors or warnings, not a valid warning-free build.
* **C90, C94, and C99:** the `c90-*`, `c94-*`, and `c99-*` tests use
  explicit `-std=iso9899:1990`, `-std=iso9899:199409`, and
  `-std=iso9899:1999`, often with `-pedantic -Wformat`.
  Warnings distinguish language editions; the C94 tests must accept
  wide conversions **without** warning in the selected dialect.
  Default compilation is not a substitute for an ISO mode oracle.
* **GNU and X/Open format extensions:** `ext-1.c` through `ext-6.c`,
  `strfmon-1.c`, and the `builtin-1.c` freestanding case require
  particular GNU-format extensions, default built-in attributes,
  long-long and wide-character type handling, and the original
  warning behavior. Historical `format.h` has type-selection macros
  that depend on the target's integer and character representations;
  PDP-10's 36-bit words and 9-bit character units must not be
  interpreted as an 8-bit/32-bit host baseline.
* **Warning policy and security:** `no-exargs-*`, `no-y2k-1.c`,
  `nonlit-*`, `plus-1.c`, and `sec-1.c` require the original
  `-Wno-format-extra-args`, `-Wno-format-y2k`,
  `-Wformat-nonliteral`, `-Wformat=2`, or `-Wformat-security`
  switches, including required warnings that must survive suppression.
  Accepting the source without inspecting warnings is a false positive.
* **Format expression and precise error handling:** `array-1.c`,
  `branch-1.c`, `diag-1.c`, and `errmk-1.c` require diagnostics for
  constant-array format strings, conditional string selection,
  malformed format modifiers, or a real undeclared variable error.

KCC suitability was independently assessed for every source, and no
KCC registration was justified: GNU format/format_arg attributes,
the precise GCC `-Wformat` family, the strict GCC language-mode
warning policy, and their expected diagnostics have not been proven
equivalent under KCC. These sources remain useful for future GCC
format-checker or diagnostic-harness development, so none is
classified permanently inapplicable.

### Same-name overlap

The original `gcc.dg/format/array-1.c` has a namesake at
`tests/codegen/upstream-gcc/gcc-dg/array-1.c`, but the latter checks
an unrelated character-array declaration/compile case, rather than
format warnings on constant arrays. The source/oracle identity is
therefore not merged or marked active.

## Reproducibility and next stage

`tools/inventory-gcc-unmirrored-v1.py` now verifies the exact source
order and SHA256 of all 50 format originals, DejaGNU action and
command-line options, per-source diagnostic annotation counts,
`format.h` ownership, and the fact that none has an active matrix
registration. It retains all earlier batch tests, confirms the
original 679-row source ledger, **585 retained original snapshots**, and
the unchanged **94 inapplicable deletion tombstones**. The refreshed
structural overlap index from batch 10 remains valid: there are no
new active test sources and no deleted sources in this batch.

After batch 11, **105 historical original sources remain unresolved**:
**101 unreviewed** and **four same-name candidates**. Batch 12 should
continue with the next 50, preserving this strict policy of matching
original diagnostic assertions rather than counting ordinary
successful compilation as equivalent coverage.

**No compiler, assembler, linker, simulator, emulator, or runtime tests
were executed.** Only source inspection, provenance/ownership updates,
static validation and documentation were performed.
