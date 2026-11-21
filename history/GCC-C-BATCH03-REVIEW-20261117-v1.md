# Historical GCC C integration, batch 03 of 50 (2026-11-17 v1)

## Source and assertion review

The next 50 unresolved original GCC C sources in ledger order were
read individually. All 50 come from the historical `gcc.dg` collection.
The retained original source bodies remain unchanged under
`refs/gcc-c-unmirrored-v1/gcc.dg/` at pinned GCC revision
`b0f5374f6d4462bb8759160ece635e306d90998f`. The 21 inapplicable
originals from this batch were subsequently deleted. The per-file
source hashes, original source actions, target options, original oracle,
PDP-10 compatibility, KCC applicability, adapted target hashes and
lost original conditions are recorded in
`manifests/GCC-C-BATCH03-20261117-v1.tsv`.
The deleted-source list and rejection rationales are recorded in
`manifests/GCC-C-INAPPLICABLE-REMOVALS-20261117-v1.tsv`.

| Decision | Count |
| --- | ---: |
| Adapted and registered pending | **7** |
| Deferred until original oracle can be exercised | 22 |
| Inapplicable to PDP-10 or its current toolchain | 21 |
| Total reviewed | **50** |

The **seven** new source owners comprise **three executable semantic
regressions and four compile-only codegen regressions**. Six sources
have independently meaningful C-level assertions for both KCC and GCC;
one original `unsigned long long` bit-field compiler regression remains
GCC-only because KCC's named bit-fields accept `int`/`unsigned int`/
`_Bool`, not `long long`. No source was registered solely on a filename
match with an existing test.

The new matrix entries are **28 pending GCC PDP-6 cells** (`-O0`, `-O1`,
`-O2`, `-Os` for all seven) and **12 pending KCC PDP-6 cells** (`pdp6`
and `pdp6_base` for the six shared sources). KCC's native/base matrix
columns are reused between optimized and no-optimization runs. These
numbers represent **scheduled coverage only**; no compiler, assembler,
linker, simulator or runtime test was run during integration.

## Seven source-level assertions retained

| Original GCC name | Kind | Compilers | Assertion or compilation contract |
| --- | --- | --- | --- |
| `20011008-2.c` | Runtime | GCC/KCC | Anonymous aggregate fields promote both `union` aliases: `b.y` and `e.x` must equal 15 after alternate-name writes |
| `20020108-1.c` | Compile | GCC/KCC | Narrow short-integer all-ones boundary stored through chained assignment and pointer target |
| `20020210-1.c` | Runtime | GCC/KCC | The fourth of five integer arguments must remain 1 through a forwarding call |
| `20020220-1.c` | Compile | GCC | `unsigned long long` bit-field assignment, narrow 18-bit extraction, and resulting expression type must not crash GCC |
| `20020222-1.c` | Compile | GCC/KCC | Static 256-character array writes through integer loops, including numeric and alphabetic indices |
| `20020310-1.c` | Runtime | GCC/KCC | Struct pointer chain, signed -1-to-0 increment, and two global field/pointer updates |
| `20020411-1.c` | Compile | GCC/KCC | Mixed-width integer bit-field assignments and inline-call narrowing, crossing a 36-bit word boundary |

The `20020108-1.c` source changes the i686 `0xFFFF` constant to
PDP-10 octal `0777777U`: this preserves the **all-ones 18-bit**
`unsigned short` boundary instead of testing a 16-bit value well below
the PDP-10 short limit. The original 16-bit test remains intact in
its pinned GCC snapshot. The C89 code (aside from original compiler
extensions) has no operating-system dependencies. The
`20020220-1.c` source is **compile-only despite containing main**:
its uninitialized local member is not evaluated at runtime by this
matrix group; the original test was a compiler ICE check.

The anonymous-member test uses the original GNU/C11 extension and is
supported by KCC's anonymous aggregate implementation. The bit-field
cases are intentionally divided by language contract: the smaller
`unsigned` fields are shared, while `unsigned long long` bit-fields
remain GCC-only rather than pretending KCC's integer bit-fields are
equivalent. Each original DejaGNU target/optimization restriction is
still documented even when the adapted C-level assertion is portable;
this batch does not claim to reproduce a foreign target's machine-code
failure or its precise register-allocation path.

## Cases deliberately not activated

Twenty-two cases are **deferred** because the meaningful original
condition is absent from the current matrix. They include GCC legacy
`-fssa`, `-fssa-ccp`, `-fprefetch-loop-arrays`, `-finline-limit`,
`-fprofile-arcs`, `-ffast-math`, `-fforce-addr`, and specific
`-O3`/`-g`/`-Werror`/`-Wtraditional` or `-Wall` combinations.
The `dg-warning`, `dg-bogus`, `dg-error` and expected-XFAIL cases also
require positive and negative diagnostic assertions, not a successful
compile with stripped warning comments. No changes were made to the
user's concurrent negative-policy edits in `SPECIAL_TESTS.tsv` and the
compiler-negative-policy tools. KCC extension policy matters: GNU
nested functions are deliberately unsupported, while GCC local codegen
features do not automatically carry to KCC.

Twenty-one cases are **inapplicable**: x86 fixed-register asm and MMX,
IA-64 relocation or bundled instruction scheduling, CRIS invalid-asm
modifiers, SPARC CPU option conflicts, Alpha IEEE/FP register details,
PowerPC 16-unit stack alignment and the x87 80-bit layout. These have
no equivalent PDP-10 oracle. The giant 10,000-by-10,000 integer-array
addressing case also exceeds the native PDP-10 address space. Several
originals are deliberately compiled with invalid syntax under a
foreign diagnostic contract; removing such syntax to make them build
would destroy the regression.

All 50 individual inclusion/exclusion decisions and the precise
qualifications are in the TSV. Existing same-name files were compared:
none of the overlaps is proof that the source's historical assertion
has already been covered.

## Reproducibility and next stage

The `tools/inventory-gcc-unmirrored-v1.py` verifier checks that batch
03 is **exactly the next 50** unresolved entries after batches 01 and
02, checks the original and adapted SHA256 fingerprints, validates
per-source compiler scope, and rejects unexpected matrix cells or
unowned new C files. This static check also preserves the prior two
batches and the 30-source KCC sharing crosswalk.

At completion, **505** of the original 679 sources still await full
assertion-level review: **21** same-name candidates and **484** other
unreviewed files. Batch 04 will continue with the next 50 in ledger
order and review KCC applicability in the same pass. No compilation or
emulation tests have been performed for batch 03.
