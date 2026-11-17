# Historical GCC C integration, batch 05 of 50 (2026-11-17 v1)

## Scope and provenance

The next **50 unresolved original GCC C sources** after batches 01-04 were
reviewed in ownership-ledger order. All are historical `gcc.dg` C files.
Their original byte-for-byte snapshots remain under
`refs/gcc-c-unmirrored-v1/gcc.dg/`, pinned to GCC revision
`b0f5374f6d4462bb8759160ece635e306d90998f`. Every original was
inspected for the DejaGNU action and assertion, GCC options, PDP-10
ABI implications, KCC applicability, and existing test ownership.

The source-hash-pinned 50-row ledger is
`docs/GCC-C-BATCH05-20261117-v1.tsv`. It records the original oracle,
`dg-options`, the target restriction, compatibility/deferral decisions,
new source hashes, **exact compiler matrix profiles** and the original
conditions that the current matrix does not reproduce.

| Disposition | Sources |
| --- | ---: |
| Registered as new pending tests | **4** |
| Deferred, original oracle not yet exercisable | 45 |
| Inapplicable to the PDP-10 representation | 1 |
| **Reviewed** | **50** |

## Four integrated oracles

The following are new versioned owners. A `pending` matrix cell records
eligibility only, **not a passing, compiling, or executed test**.

| Historical source | Test kind | Compiler scope and exact profiles | Preserved assertion |
| --- | --- | --- | --- |
| `attr-alwaysinline.c` | Codegen | GCC PDP-6 `-O0` **only** | `always_inline` must suppress any emitted `sabrina` symbol even at `-O0`; native `codegen-forbid-regex` checks the original `scan-assembler-not` assertion |
| `builtin-choose-expr.c` | Runtime | GCC PDP-6 `-O1` **only** | `__builtin_choose_expr` selects proper types, constant expressions and lvalues, preserves the selected object update, and invokes the selected function pointer |
| `c99-array-lval-3.c` | Codegen | GCC PDP-6 `-O0/-O1/-O2/-Os`; KCC PDP-6 native/base | C99 permits array-member decay in expressions involving temporary aggregate values and non-lvalue struct expressions; source is a positive compile-only oracle |
| `c99-bool-1.c` | Runtime | GCC PDP-6 `-O0/-O1/-O2/-Os`; KCC PDP-6 native/base | Full source `_Bool` oracle: true/false macros, compile-time `#error` guards, scalar and pointer conversion, increment/decrement, arithmetic/logic, assignment and bitfield behavior |

The exact selection adds **10 pending GCC** compiler cells (one forced
inline, one choose expression, four each of the C99 tests) and **four
pending KCC** cells (two C99 tests times native/base). No other CPU or
compiler profile is enabled. An additional explicit `gcc_profiles`/
`kcc_profiles` field records each source's allowed matrix columns.

KCC recognizes the GNU `always_inline` attribute but treats it as
correctness-neutral metadata; therefore it **cannot** share GCC's
forced-inlining assertion. KCC also does not implement GCC
`__builtin_choose_expr`; that test remains GCC-only. The boolean
source is complementary to the existing KCC `bool-semantics.c` test:
its original includes `stdbool.h` macro-stringization and compile-time
checks, a larger set of unary/binary/compound operations, and explicit
bitfield updates. The testkit's `support/include/stdbool.h` provides
the C99 macros for GCC and KCC. The C99 non-lvalue array decay source
has no `dg-error` or `dg-bogus` requirement and is registered only as
a positive compile-only C99 expression test; KCC capability remains
**unverified until execution**.

The original sources selected an explicit `-std=iso9899:1999
-pedantic-errors` for the C99 tests. The current generic compiler
matrix does not pass this strict-mode option, so these registrations
**do not establish strict C99 conformance, error severity, or lack of
pedantic warnings**. They test the actual source-level expression or
runtime behavior under supported default compiler modes. Similarly,
the original choose-expression test used `-O1 -Wall`, but this
registration preserves `-O1` and the runtime assertions, **not**
`-Wall` diagnostics. No diagnostic expectations were silently removed
from a test that required positive/negative DejaGNU output matching.

## Forty-five deferred sources

This batch is predominantly a C90/C99 language-mode and diagnostics
sweep, so deferral is expected when the strict dialect or exact
warning/error oracle is unavailable.

* **9 attribute/assembler and bitfield diagnostics** (`asm-6.c`,
  `asm-fs-1.c`, `asm-names.c`, `attr-invalid.c`, `attr-nest.c`,
  `attr-noinline.c`, `attr-used.c`, `bitfld-1.c`, `bitfld-2.c`).
  Required `dg-error`, `dg-warning`, `dg-bogus`, assembly scans,
  `dg-do link`, `-ffunction-sections`, `-fdata-sections`, or `-O3`
  cannot be replaced with default compile success. The two same-name
  bitfield files elsewhere in the testkit do not cover these warning
  and XFAIL contracts.
* **29 C90/C94 strict-mode sources** (`c90-array-lval-*`,
  `c90-arraydecl-*`, `c90-complex-*`, `c90-complit-*`,
  `c90-const-expr-*`, `c90-digraph-*`, `c90-enum-comma-*`,
  `c90-float-*`, `c90-fordecl-*`, `c90-hexfloat-*`,
  `c90-idem-qual-*`, `c90-impl-decl-*`, `c90-impl-int-*`,
  `c90-init-*`, `c90-intconst-*`, `c90-longlong-*`,
  `c90-mixdecl-*`, `c90-restrict-*`, `c90-return-*`,
  `c90-scope-*`, `c94-digraph-*`). The tests depend on explicit
  `-std=iso9899:1990`/`-std=iso9899:199409` modes and often
  `-pedantic-errors`, required diagnostics or forbidden warnings.
  The original 763-line `c90-intconst-1.c` additionally tests
  integer constant *types* across width-dependent decimal/octal/hex
  boundaries and warning cases. Admitting it without mode and diagnostic
  mapping would not establish the original 36-bit/71-bit PDP-10 rules.
* **7 other C99 sources** (`c99-array-lval-1.c`, `-2.c`, `-4.c`,
  `-5.c`, `c99-array-nonobj-1.c`, `c99-arraydecl-1.c`,
  `c99-complex-1.c`). These mix C99 expression/array/type acceptance
  with explicit `dg-bogus` or `dg-error` expectations. In particular,
  the non-lvalue address-of sources are **negative** tests and must not
  be registered as ordinary compilation tests. The GNU/C99 complex
  diagnostic case is not a KCC complex-feature coverage claim.

## One inapplicable test

`bf-spl1.c` asserts an IEEE double union representation with a **52-bit
fraction**, 11 exponent bits, one sign bit and a packed 64-bit
`DI` mode. PDP-10 double and normalized **71-bit** `long long`
representations are different; KCC does not support a comparable
52-bit packed bitfield. Replacing those types would erase the original
bit-level assertion, so the source remains archived and inactive.

## Static reproducibility and continuation

`tools/inventory-gcc-unmirrored-v1.py` now checks that batch 05
contains exactly the next 50 original sources; it verifies their
original and adapted SHA256 hashes, KCC/GCC profile selections,
compiler matrix groups, inactive cells, and ownership of all new
source files. The earlier batch decisions and 30-source KCC historical
review remain unchanged. This is a static integrity/eligibility gate;
**no compiler, linker, assembler, simulator, or runtime tests were run**.

After batch 05, **405** of the 679 original sources remain without a
completed assertion-level review: **12 same-name candidates and 393
unreviewed originals**. Batch 06 will continue from those entries,
including explicit KCC applicability and distinction between execution,
assembly-output, diagnostic and preprocessor oracles.
