# Historical GCC C integration, batch 06 of 50 (2026-11-17 v1)

## Scope, originals, and review rules

Batch 06 examines exactly the next 50 unresolved original GCC C files
in the source-ownership ledger, following the five earlier 50-source
batches. The originals are under `gcc/testsuite/gcc.dg/`, including
five sources from `gcc.dg/cpp/`. Their original byte-for-byte snapshots
remain preserved under `refs/gcc-c-unmirrored-v1/`, pinned to GCC revision
`b0f5374f6d4462bb8759160ece635e306d90998f`.

The source-level ledger `docs/GCC-C-BATCH06-20261117-v1.tsv`
records each original source and SHA256, the `dg-do` action, original
assertion, original options/target, C/ABI/ISA analysis, explicit KCC
eligibility, adapted source SHA256 where applicable, exact compiler
profiles, and qualifications. Original source names were not treated
as equivalent to unrelated testkit files with matching basenames.

| Decision | Original files |
| --- | ---: |
| Registered as pending | **12** |
| Deferred for missing mode, diagnostics, or other original assertion | 37 |
| Inapplicable foreign instruction set | 1 |
| **Reviewed** | **50** |

The 12 new test owners consist of **9 semantic runtime tests and 3
codegen compile-only tests**. Nine source assertions have a meaningful
KCC counterpart, while three are GCC-only pending checks. Nothing was
compiled, assembled, linked, emulated or executed; the matrix statuses
are scheduling assertions, not results.

## Twelve active source owners

All entries below are direct, minimally wrapped adaptations of the
pinned original source. The native testkit does not interpret the
original DejaGNU selector comments: only those whole-line driver
selectors were omitted. The source tests' actual executable and
compile-time checks remain. Source hashes are in the companion TSV.

| Original | Test group | KCC eligibility | Preserved assertion |
| --- | --- | --- | --- |
| `c99-complit-1.c` | Runtime | GCC/KCC | Compound literal global and block-scope storage, independent object addresses, array/aggregate initialization, mutation, `sizeof`, and loop lifetime |
| `c99-condexpr-1.c` | Compile | GCC/KCC | Compile-time `__typeof__` type identity for C99 conditional expressions, pointer qualifications, null-pointer expressions, and aggregate types |
| `c99-digraph-1.c` | Runtime | GCC only | C99 digraph `%:%:` pastes `1` and `2` into `12`, while `<:` is stringized as `<:` |
| `c99-enum-comma-1.c` | Compile | GCC/KCC | C99 trailing comma in enum definition is accepted |
| `c99-fordecl-1.c` | Runtime | GCC/KCC | Three loop-initializer declaration forms sum to 55 and preserve the outer variable `i == -1` |
| `c99-func-1.c` | Runtime | GCC/KCC | `__func__` contains `main` and has five `char` elements including the terminator |
| `c99-func-3.c` | Runtime | GCC only | C99 `__func__` denotes a distinct object from the ordinary string literal `"main"` |
| `c99-hexfloat-2.c` | Runtime | GCC only | C99 hex pp-number tokenization and macro stringization must yield `"0x1p+f 0x1p+l"` |
| `c99-mixdecl-1.c` | Runtime | GCC/KCC | Declarations following statements retain correct initializers and subsequent value checks |
| `c99-scope-1.c` | Runtime | GCC/KCC | Struct-tag declaration inside an `if` controlling expression does not replace outer tag scope |
| `c99-scope-2.c` | Runtime | GCC/KCC | Struct tags in `if`, `else`, `switch`, `do`, `while`, and `for` controlling expressions do not leak across scopes |
| `cpp/19921210-1.c` | Compile | GCC/KCC | During macro expansion a macro is disabled within its own replacement; nested expansion yields one-element compile-time array |

The source directories are `tests/semantic/gcc-historical-b06-v1/`
and `tests/codegen/gcc-historical-b06-v1/`. The macro-expansion case
is stored in `codegen` because the actual oracle is an array declarator
with a constant-expression size: compiling the original is sufficient.

The three GCC-only cases have specific KCC caveats:
`c99-digraph-1.c` and `c99-hexfloat-2.c` require C99 preprocessor
lexing whose exact KCC behavior has not been verified. For
`c99-func-3.c`, the KCC lexer currently substitutes a string literal
token for `__func__`; therefore it must **not** be assumed to implement
the distinct array-object identity asserted by the source. KCC does
have relevant previously registered tests for compound literals,
`typeof`, loop-declaration scope, and function-name text, supporting
the nine shared **pending** eligibility decisions.

All registered cases use the four current GCC PDP-6 optimization
profiles (`-O0`, `-O1`, `-O2`, `-Os`). The nine KCC-shared cases also
use `pdp6` and `pdp6_base`. This adds **48 pending GCC** and
**18 pending KCC** matrix cells. Other profiles remain `no_test`.
The original C99 tests use `-std=iso9899:1999 -pedantic-errors`, but
the generic compiler profiles do **not** enforce that strict language
mode or pedantic diagnostic severity. These registrations test the
source-level C99 semantics under existing compiler defaults; they do
**not** establish full ISO C99 pedantic conformance. Preprocessor
behavior is checked via the original runtime or compile-time assertion,
not by replacing the original logic with unconditional success.

## Thirty-seven explicitly deferred source assertions

Every deferred source has an individual reason in the TSV. Key groups:

* **Strict C99 negative diagnostics:** `c99-complex-2.c`,
  `c99-complit-2.c`, `c99-flex-array-1.c`, `c99-flex-array-2.c`,
  `c99-fordecl-2.c`, `c99-func-2.c`, `c99-func-4.c`,
  `c99-impl-decl-1.c`, `c99-impl-int-1.c`, `c99-impl-int-2.c`,
  `c99-init-2.c`, `c99-restrict-1.c`, `c99-return-1.c`, and
  `c99-tag-1.c`. They require numerous `dg-error`/`dg-bogus` tests
  and must not be registered as successful compilations.
* **Strict C99 acceptance, no-warning, XFAIL, or width-sensitive
  cases:** `c99-const-expr-1.c` through `-3.c`, `c99-float-1.c`,
  `c99-hexfloat-1.c`, `c99-idem-qual-1.c`,
  `c99-longlong-1.c`, `c99-main-1.c`, and `c99-intconst-1.c`.
  The 644-line integer-literal oracle has `dg-excess-errors` and
  depends on C99 literal type/width rules; the PDP-10 36-bit word
  and normalized 71-bit `long long` require faithful verification.
  The hosted `main` implicit-return test additionally needs original
  hosted/link and warning options. The `float.h` case is explicitly a
  **preprocess-only** macro-inventory assertion, not a compile test.
* **Initializer representation:** `c99-init-1.c` compares entire
  initialized aggregate object representations with `memcmp`, and
  checks nested/range designators and `wchar_t` strings. PDP-10 9-bit
  character, native layout and KCC/GCC initializer differences require
  a dedicated port or exact oracle audit, not silently dropping
  `memcmp` or individual field checks.
* **Compiler warnings:** `cast-qual-1.c`, `cast-qual-2.c`,
  `compare1.c` through `compare5.c`, and `concat.c` all require
  positive and/or negative diagnostics at specific source sites.
  Simply compiling their C bodies would erase the original bug.
* **Link-only coverage:** `complete-port.c` has `dg-do link` and
  exercises support-library arithmetic helpers. The native
  codegen compile-only group does **not** reproduce a link oracle.
  Its `foo`/`dfoo` static lookup tables would also be overrun if
  the source were indiscriminately executed.
* **Preprocessor negative checks:** `cpp/19930510-1.c`,
  `cpp/19940712-1.c`, `cpp/19951025-1.c`, and
  `cpp/19951227-1.c` require expected errors for invalid directives,
  unterminated comments across includes, malformed includes, or
  pp-number suffixes. Companions remain in the historical archive.

## One inapplicable source

`clobbers.c` uses literal x86 `movl` and `xorl` instructions and six
x86 general-register clobber lists. Neither PDP-10 GCC nor KCC can
exercise this ISA-specific clobber convention. Replacing the assembly
with C assignments would eliminate the entire original assertion.

## Static verification and next batch

The static inventory checker `tools/inventory-gcc-unmirrored-v1.py`
verifies that this batch comprises **exactly the next 50** unresolved
originals, both original/adapted source SHA256 fingerprints, every
per-compiler pending cell, empty cells in unreviewed profiles, and
absence of unowned batch06 C files. Prior batches and the 30-source
historical KCC eligibility crosswalk remain protected.

After batch 06, **355** of the 679 historical sources remain unresolved:
**12 same-name candidates** and **343 otherwise unreviewed**.
Batch 07 should review the next 50 in ledger order while continuing
to preserve diagnostics, exact compiler options and cross-compiler
applicability. **No compiler, assembler, emulator or runtime tests were
executed for this batch.**
