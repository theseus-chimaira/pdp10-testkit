# Historical GCC C integration, batch 08 of 50 (2026-11-17 v1)

## Source baseline and review scope

Batch 08 reviews exactly the next 50 unresolved original GCC C sources
in historical source-order, after batches 01-07. Every source is from
`gcc/testsuite/gcc.dg/cpp/`, the GNU C preprocessor regression tests.
The archived source bodies remain unchanged in
`refs/gcc-c-unmirrored-v1/gcc.dg/cpp/`, pinned to historical GCC
revision `b0f5374f6d4462bb8759160ece635e306d90998f`.
All 89 inapplicable originals previously deleted remain absent; their
original identities and SHA256 hashes remain in the 679-row preflight
and ownership ledger and the existing versioned deletion manifest.

The 50-row `manifests/GCC-C-BATCH08-20261117-v1.tsv` records original
source fingerprint, test directive and options, original compiler/
preprocessor oracle, separate PDP-10 and KCC assessment, disposition,
compiler eligibility, exact pending profiles, adapted source/hash,
and the constraints the current matrix cannot exercise.

| Decision | Source count |
| --- | ---: |
| Register as pending | **7** |
| Defer pending original options, diagnostics, or output assertions | 43 |
| Inapplicable (delete) | 0 |
| **Reviewed** | **50** |

Two registrations are runtime tests; five are compile-only or
preprocessor checks. Four test assertions are eligible for both
GCC and KCC; the other three are GCC-only. These are eligibility
reviews only, not execution results.

## Seven active source owners

| Original C source | Registration | PDP-10/KCC original oracle |
| --- | --- | --- |
| `digraphs.c` | GCC-only runtime | C99 digraph `#`, `##`, `[`, `]`, `{`, `}` spellings, paste and stringify; runtime `strcmp` asserts spellings are preserved |
| `ident.c` | GCC-only compile | Accept original GNU `#ident "this is an ident"` directive followed by a valid function; does not assert linker/object `.ident` emission |
| `if-sc.c` | GCC/KCC compile/preprocess | Five guarded preprocessor expressions require `||`, `&&`, `?:` to short-circuit and not evaluate invalid divide-by-zero branches or activate `#error` |
| `if-unary.c` | GCC/KCC compile/preprocess | C preprocessor unary `+`, `-`, `~`, `!` and repeated/compound unary expressions must not activate original guarded `#error` |
| `include1.c` | GCC/KCC compile/preprocess | Macro-expanded `#include MACRO` loads original `mi1c.h`, defines `CPP_MIC_H`, and avoids original `#error` |
| `line4.c` | GCC/KCC compile | Original `#line` literal and macro values must give `__LINE__` 44, 90 and 19 at three negative-array-bound guards |
| `mac-dir-1.c` | GCC-only runtime | GNU directives inside macro argument lists, including conditional source and a mid-invocation `#undef`/`#define`, must satisfy both original `abort()` checks |

The source files reside in
`tests/codegen/gcc-historical-b08-v1/` (five source owners) and
`tests/semantic/gcc-historical-b08-v1/` (two owners). Every registered
source retains its entire original body, including DejaGNU comments.
For `if-sc.c`, `if-unary.c`, and `include1.c`, exactly one native
`/* codegen-kcc-preprocess: source */` directive is prepended so KCC
uses its `-E` preprocessor instead of treating a purely preprocessing
translation unit as a program. GCC compile-only profiles also invoke
the original preprocessing checks. The verifier checks the exact
prefix and otherwise unchanged original bytes and SHA256 fingerprints.

`mac-dir-1.c` preserves the pinned original source's mixed space/tab
indentation on line 21 (four spaces followed by one tab before `1))`).
Git flags this historic whitespace as `space before tab in indent`.
The staged whitespace check excludes only this one original file;
its entire contents and SHA256 are separately compared byte-for-byte
to the archived GCC source. All other batch08 files remain subject to
strict staged whitespace checking.

`include1.c` needs its original `mi1c.h` copied beside it, retaining
both comments and null directives. The header copy is byte-for-byte
identical to its retained source snapshot and its path, SHA256, and
owner are separately pinned in
`manifests/GCC-C-BATCH08-COMPANIONS-20261117-v1.tsv`.
The existing archived `mi1c.h` remains available for deferred
preprocessor tests; no original companion or deferred source was removed.

The GCC-only decisions avoid claiming KCC handles all six digraphs,
GCC `#ident`, or the directive-inside-macro-argument extension. The
`digraphs.c` source originally selected `-std=c99`; generic GCC
optimization profiles do **not** select strict ISO C99 mode. The
registered runtime test therefore checks the original digraph behavior,
not strict C99 mode gating. The `mac-dir-1.c` source has two historical
`dg-do` comments (`preprocess`, then `run`); it contains explicit
runtime abort assertions and is registered as a runtime test so those
assertions are not lost.

Only the four existing PDP-6 GCC optimization profiles (`-O0`, `-O1`,
`-O2`, and `-Os`) and, for the four shared tests, the KCC `pdp6`
and `pdp6_base` profiles are pending. This adds **28 pending GCC**
and **8 pending KCC** matrix cells. Every other compiler/CPU profile
for these owners is `no_test`.

## Forty-three deferred source contracts

The full TSV records one independent reason per source. The major
categories are as follows:

* **Required GCC errors, warnings, and their locations:** `defined.c`,
  `defined_trad.c`, `direct2.c`, `direct2s.c`, `directiv.c`, the
  `endif-pedantic*`, `escape*`, `extratokens*`, `if-1.c`, `if-2.c`,
  `if-4.c`, `if-5.c`, `if-cexp.c`, `if-mop.c`, `if-mpar.c`,
  `if-oppr.c`, `if-paren.c`, `line2.c`, `line3.c`, `mac-dir-2.c`
  and others. Their explicit `dg-error`, `dg-warning`, `dg-bogus`
  assertions must not be replaced by unconditional successful
  compilation; some test recovery after multiple invalid directives.
* **Language modes and essential flags:** `digraph1.c` and
  `digraph2.c` test opposing digraph interpretation in ISO C94 versus
  C89. `gnuc89*` and `gnuc99*` distinguish dialects, pedantic
  warnings, and the `LL` integer suffix. `hash2.c` uses
  `-traditional`; `fpreprocessed.c` and `line5.c` require
  `-fpreprocessed`. The current matrix profiles do not reproduce
  those specifically selected modes.
* **Preprocessed output assertions:** `line1.c` uses a `dg-final`
  grep for `#line` output. `maccom1.c` uses `-CC` and requires
  an exact expansion/output assertion, not simply a successful parse.
  These are preserved for an output-aware preprocessor harness.
* **PDP-10 width or token assumptions:** `if-3.c` hardcodes 32-bit
  unsigned and 64-bit `long long` widths and shifts by 63, while
  PDP-10 uses 36-bit native `int` and a distinct long-long model.
  `if-shift.c` uses negative shift counts, whose CPP handling is
  compiler-specific rather than portable C. `lexident.c`,
  `lexnum.c`, and `lexstrng.c` require explicit `-trigraphs`, with
  additional floating, string, or wide-character assertions in the
  runtime cases. These cannot be enabled by silently dropping
  essential flags or width expectations.

None of these 43 cases was proved permanently inapplicable. They
remain archived for their original diagnostics, output or options,
and the existing 89-source deletion tombstone manifest is unchanged.

## Verification and continuation

The static inventory verifier `tools/inventory-gcc-unmirrored-v1.py`
checks that this is exactly the next 50 source identities, all original
and adapted hashes, the three permitted KCC preprocessor directives,
seven exclusive owners, two test categories, KCC/GCC profile scope,
all 43 nonactive dispositions, and the original single required
`mi1c.h` header. Prior batch checks and all 89 deleted-source
assertions remain in force. No source is allowed to become an
active test simply because it shares a filename with another source.

After batch 08, **255** of the initial 679 sources remain unresolved:
**246 unreviewed originals** and **9 same-name candidates**. Batch
09 should review the next 50 in original source order, with the same
strict original-oracle and KCC suitability policy.

**No compiler, assembler, linker, simulator, emulator, or runtime
tests were executed as part of this batch.** All work is static
source inspection, registration, provenance and documentation.
