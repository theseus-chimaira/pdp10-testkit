# Historical GCC C integration, batch 09 of 50 (2026-11-17 v1)

## Source provenance and disposition

Batch 09 reviewed exactly the next **50 previously unresolved** original
GCC C source files in the immutable 679-original preflight order,
after batches 01-08. All originate in `gcc/testsuite/gcc.dg/cpp/` and
retain their original byte-for-byte snapshots under
`refs/gcc-c-unmirrored-v1/gcc.dg/cpp/`. Their provenance is pinned to
historical GCC revision `b0f5374f6d4462bb8759160ece635e306d90998f`.
The previous **89 inapplicable source snapshots remain deleted**;
their exact identities and hashes remain in the original preflight,
review-ledger and deletion-tombstone manifest.

The new source-level review ledger
`manifests/GCC-C-BATCH09-20261117-v1.tsv` records the **50 original SHA256
fingerprints**, exact source/compiler action and option directives,
the actual original oracles, individual PDP-10 suitability, separate
KCC eligibility, disposition, test ownership, adapted source hash,
exact pending compiler profiles and any original behavior not covered.
No filename-only equivalence decision or compiler pass substitution
for required negative diagnostics is permitted.

| Disposition | Count |
| --- | ---: |
| New test owners registered pending | **19** |
| Deferred while preserving the original oracle | **31** |
| Inapplicable and deleted | **0** |
| **Reviewed** | **50** |

The 19 owners include **11 runtime** tests and **eight compile-only or
preprocessor** tests. Fourteen have a compatible candidate for KCC;
five are GCC-only. The native testkit matrix adds **76 pending GCC
PDP-6 optimization cells** and **28 pending KCC PDP-6 native/base
cells**. None of these entries is a measured compiler or runtime pass.

## Nineteen registered original source tests

The tests reside in `tests/semantic/gcc-historical-b09-v1/` (11 C
sources) and `tests/codegen/gcc-historical-b09-v1/` (eight C sources).
All selected C sources preserve their entire original bodies, DejaGNU
comments and whitespace. Four preprocessor-only originals carry a
single extra native `/* codegen-kcc-preprocess: source */` header
comment so KCC runs its actual `-E` preprocessor rather than compiling
invalid or empty C code. The original bodies and adapted fingerprints
are verified byte-for-byte, including their source-level assertions.

Seven copied historical originals preserve existing whitespace that
Git flags: trailing spaces in `macro3.c`, `macro11.c`, `mi2a.h`,
`mi2b.h`, `mi2c.h`, and `mi3.def`, plus a whitespace-only line in
`paste2.c`. The six unchanged files are compared byte-for-byte against
the archived originals; `macro11.c` has exactly one pinned KCC
preprocessor comment prepended, and its remaining source bytes match
the original. All seven adapted SHA256 fingerprints are verified.
Strict staged
Git whitespace checking excludes only these seven original files;
all other changed files are checked normally. Stripping the original
whitespace would mutate historical regression inputs.

| Test | KCC eligibility | Preserved original source-level behavior |
| --- | --- | --- |
| `macro1.c` | Shared | Multiple nested/rescanned macro expansion and recursion cases must all produce 42 or exact `forty`/`forty-two` strings at runtime |
| `macro11.c` | Shared | Macro initially defined to itself, then undefined/redefined as 1, must not leave `#if !foo` active |
| `macro3.c` | Shared | C99 variadic macro invocation and recursive macro suppression; runtime checks 4 and 100 |
| `macro4.c` | Shared | Nested glue/xglue macro rescan must form numeric token 12 or trigger `#error` |
| `macro5.c` | Shared | Simulated variadic argument/glue constructs must evaluate to 42 or trigger `#error` |
| `macro6.c` | Shared | Macro expansion spilling into the original source must yield 14, 108 and 120 or abort |
| `macro8.c` | GCC only | GNU named rest arguments, `##args` comma swallowing and function invocation expansion must produce 5 and 7 without abort |
| `macro9.c` | Shared | Directive between function-like macro name and later source must still produce a valid `int main()` definition |
| `mi2.c` | Shared | Nested `mi2a.h`/`mi2b.h` inclusion with changed `need_x` conditions must expose declaration of `x` |
| `mi3.c` | Shared | Reinclude `mi3.def` with changed `X`, then include `mi3.h` twice; declarations `a`, `b`, and `c` must all exist |
| `mi4.c` | Shared | Undefine the include guard and reinclude original `mi1c.h` without stale include-cache handling |
| `mi6.c` | GCC only | Five distinct macro-formed conditional include guard patterns must increment `five` to exactly 5 |
| `paste2.c` | GCC only | Runtime C99 preprocessor `##` paste of digraphs, placemarkers, punctuation operators, numbers and variadic macro operands |
| `paste3.c` | Shared | C parser must accept correctly spaced `1 + ++b` from `1 plus++b`, not incorrectly concatenate into `+++` |
| `paste7.c` | Shared | Recursive paste and macro argument rescan must set two global variables to 1 and 2 |
| `paste9.c` | GCC only | GNU named varargs and comma elision must retain the constructed newline detectable by `strchr` |
| `strify3.c` | GCC only | Macro stringization of `foo@bar` must not introduce a space between the two operands |
| `strp1.c` | Shared | Stringize decimal preprocessing number `1.1` and nested macro `f(1)(2)` to exact expected strings |
| `strp2.c` | Shared | `# ## #` paste followed by stringization must produce the exact text `x ## y` |

### Original action versus native strengthened checks

`macro8.c` and `mi6.c` used original `dg-do compile` actions, although
both contain nonvacuous `main()` error checks with calls to `abort()`.
The native registration selects **runtime**, explicitly extending
the original compilation requirement by exercising those source
checks. The original compile-only oracle is still a prerequisite
and no source assertion has been removed. The generic GCC profiles
do not select the original `macro8.c` `-std=gnu89` dialect; its
GNU named-varargs expansion is checked semantically, not under a
strict GNU89 dialect-mode contract. Similarly, `macro3.c` and
`paste2.c` had explicit `-std=c99` (the latter also
`-pedantic-errors`), which the generic optimization profiles do not
select. Their complete source-level semantic assertions are retained;
no strict C99 diagnostic compliance is claimed.

KCC pending coverage is restricted to candidate-compatible C macro
expansion, including the established `__VA_ARGS__` syntax, recursive
expansion, `#if` guards, token paste, and local included headers.
GCC-only classifications apply to the GNU named-rest and optional
comma-elision behaviors, unusual macro-expanded `defined` include
guards, full C99 digraph/placemarker paste, and the `@` stringization
token whose KCC interpretation has not been established. These are
**eligibility decisions**, not claims that any compiler already passes.

## Eleven original include companions retained intact

The four tests with test-local included files require the following
exact original include graphs; the testkit does not flatten or
replace these headers with fabricated declarations:

| Source owner | Copied original companions | Assertion |
| --- | --- | --- |
| `mi2.c` | `mi2a.h`, `mi2b.h`, `mi2c.h` | `mi2c.h` must reprocess after the controlling macro changes |
| `mi3.c` | `mi3.def`, `mi3.h` | Definitions depend on the include sequence and current macro values |
| `mi4.c` | `mi1c.h` | Reinclude after clearing `CPP_MIC_H` |
| `mi6.c` | `mi6a.h`, `mi6b.h`, `mi6c.h`, `mi6d.h`, `mi6e.h` | All five guards become active on the second pass |

All **11 original companion files** are copied byte-for-byte into
the relevant versioned source directory (including the `.def` file),
and their source SHA256, adapted path/hash and owning test are pinned
in `manifests/GCC-C-BATCH09-COMPANIONS-20261117-v1.tsv`. The original
historical archive retains the existing **25 quoted-include companions**;
no archived source or companion was removed in this batch.

## Thirty-one deferred original oracles

Every deferred source has a separate detailed rationale in the TSV;
representative categories are:

* **Actual preprocessed-output comparisons:** `maccom2.c` through
  `maccom6.c` require GCC `-CC` and `dg-final` text greps checking
  comment preservation and macro output. `spacing1.c` and `spacing2.c`
  inspect emitted whitespace and line placement. These tests cannot
  be replaced with compilation or general macro expansion checks.
* **Preprocessing-only input without a valid C translation unit:**
  `macro10.c`, `macro2.c`, `macro7.c` and `paste10.c` test scanner
  recovery and macro suppression on raw textual output. Their original
  source bodies are not valid normal C translation units; promoting
  them to compile-only would claim an unrelated failure. They require
  an explicit GCC preprocessor-only success profile.
* **Original diagnostics, warnings, and exact line locations:**
  `macsyntx.c`, `paste1.c`, `paste11.c`, `paste4.c`, `paste5.c`,
  `paste6.c`, `paste8.c`, `poison.c`, `pragma-1.c`, `pragma-2.c`,
  `redef1.c`, `redef2.c`, `skipping.c`, `skipping2.c`, `strify1.c`,
  and `syshdr.c` require `dg-warning`, `dg-error`, or `dg-bogus`
  assertions. Some deliberately contain invalid syntax or require
  warnings absent in system headers but present in user headers.
* **Exact include-trace suppression:** `mi1.c` and `mi5.c` use
  `-H` or `-H -C` and demand a matching emitted include sequence;
  mere successful compilation would miss the original include-cache
  regression. `multiline.c` similarly requires `-C`, diagnostic
  text and no-blank-line output assertions.
* **Target/encoding-sensitive lexing:** `strify2.c` contains raw
  non-ASCII source bytes, 8-bit-oriented string/escape expectations,
  required invalid-paste warnings, and strict C99 options. A PDP-10
  adaptation must not silently discard the warnings or change the
  character-data assertions.

No source was established as inapplicable to all PDP-10 toolchain
configurations, so **zero** new deletions or tombstone entries were
made. The prior 89 inapplicable source deletions remain in effect.

## Static validation and next stage

`tools/inventory-gcc-unmirrored-v1.py` verifies this batch's exact
50-source order, source fingerprints and complete positive/negative
decisions, 19 unique native owners, exact source byte preservation,
four KCC preprocess directives, all permitted GCC/KCC `pending`
profiles, and 11 include companions with original SHA256 hashes.
It retains the earlier eight batch audits, the 679-row historical
source ownership census, and the 89-source absence/tombstone checks.

After batch 09, **205 original source reviews remain unresolved**:
**196 unreviewed** plus **nine same-name candidates**. The next step
is batch 10, again reviewing exactly 50 unresolved originals in
provenance order, without promoting diagnostic-only cases to positive
compiler passes.

**No compiler, assembler, linker, emulator, simulator, benchmark or
runtime tests were executed.** The batch consists only of source-level
review, copied original tests, static source/matrix/hash audits and
documentation.
