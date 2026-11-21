# Historical GCC C integration, batch 10 of 50 (2026-11-17 v1)

## Original sources and eligibility

This review covers exactly the next **50 unresolved original GCC C
sources**, in the immutable 679-original source ledger order after
batches 01-09. The group crosses from `gcc.dg/cpp` to `gcc.dg/debug`
and then to normal `gcc.dg` diagnostics and explicitly ARM/Thumb PE
DLL sources. The pinned upstream revision is
`b0f5374f6d4462bb8759160ece635e306d90998f`.

Every row in `manifests/GCC-C-BATCH10-20261117-v1.tsv` records the original
path/SHA256, original action/options and assertion, independent PDP-10
and KCC assessment, final disposition, exact test ownership and pending
compiler profiles (if any), and unexercised original requirements.
This is a source and assertion review, not evidence of successful
compilation or execution.

| Disposition | Original C files |
| --- | ---: |
| New GCC-only pending owners | **3** |
| Deferred without loss of original oracle | 42 |
| Newly inapplicable and deleted | **5** |
| **Reviewed** | **50** |

## Three original-source regressions registered pending

The registered tests are in versioned directories, retaining **all
original bytes** (including DejaGNU comments and historical whitespace).
Unlike some earlier batches, no extra source directive or locally copied
header is needed for the three tests.

| Original | Registration | Original behavior |
| --- | --- | --- |
| `gcc.dg/cpp/vararg1.c` | `tests/semantic/gcc-historical-b10-v1/vararg1.c` | GNU named-rest variadic macros must count zero and one argument correctly in guarded `#if`, and the runtime string built using optional comma elision must contain newline (`strchr`) |
| `gcc.dg/cpp/vararg2.c` | `tests/codegen/gcc-historical-b10-v1/vararg2.c` | Extensive GNU and C99 variadic macro count, repeat, take, drop and index expansion must satisfy all original `#if`/`#error` guard comparisons |
| `gcc.dg/cpp/wchar-1.c` | `tests/semantic/gcc-historical-b10-v1/wchar-1.c` | C preprocessor wide-character expression sign must agree with the runtime compiler interpretation of `__WCHAR_TYPE__` initialized to `-1` |

All three are **GCC-only** pending registrations. The KCC sources
reviewed expose standard `__VA_ARGS__`, but do not establish the GNU
named-rest argument counting and comma-elision behavior. The KCC
predefined `__WCHAR_TYPE__` needed by the source was not found; no
unsupported KCC assertions were promoted. The original `vararg1.c`
and `wchar-1.c` use `-w` to suppress diagnostics; current profiles
exercise the runtime source conditions, **not** that exact warning
setting. `vararg2.c` originally specifies `-std=gnu99` with
`dg-do preprocess`: GCC's registered compile-only case invokes the
original preprocessor guards but does **not** establish strict GNU99
mode-selection equivalence or an original `-E` output-text result.
No required original `dg-final` text or negative diagnostics are lost
in these three semantic-source registrations.

All are pending for the four PDP-6 GCC optimization profiles
`pdp6_gcc_o0`, `pdp6_gcc_o1`, `pdp6_gcc_o2` and `pdp6_gcc_os`, adding
**12 pending GCC cells**. No KCC or other target profiles were
activated. Each original source body and adapted SHA256 are pinned
by the review TSV and verified independently. `wchar-1.c` preserves
a trailing space on source line 22. Git's whitespace check excludes
only this file, which is explicitly compared byte-for-byte to the
pinned original.

## Five inapplicable originals deleted

The following five sources are not PDP-10 tests, because their
**actual original target guard and expected output are tied to an
incompatible architecture or object format**:

| Original | Original-only target/oracle |
| --- | --- |
| `gcc.dg/cpp/tr-sign.c` | DejaGNU `dg-do preprocess` restricted to `i?86-*-*`; traditional preprocessing treats 32-bit `0xffffffff` with signed/unsigned distinctions that are different from PDP-10 36-bit integers |
| `gcc.dg/dll-1.c` | ARM/Thumb PE DLL function import/export, `-mno-nop-fun-dllimport` and exact `.drectve`/`__imp_` assembler output |
| `gcc.dg/dll-2.c` | ARM/Thumb PE `__declspec(dllimport/dllexport)` precedence for function and variable redeclarations |
| `gcc.dg/dll-3.c` | ARM/Thumb PE exported function `.drectve` output and required absence of `__imp_` imports |
| `gcc.dg/dll-4.c` | ARM/Thumb PE imported variables with local definitions, `.comm` output and no `__imp_` symbols |

Their archived `.c` snapshots have been **deleted**, not replaced
with PDP-10 workarounds. Their original SHA256 hashes and exact source
review reasons remain in the 679-row ownership ledger, the preflight,
original batch decision TSV, and the version-2 deletion manifest
`manifests/GCC-C-INAPPLICABLE-REMOVALS-20261117-v2.tsv`. The original
89-tombstone v1 manifest remains unchanged. A full 94-tombstone audit
is documented in
`history/GCC-C-INAPPLICABLE-REMOVALS-REVIEW-20261117-v2.md`.

The source verifier and `--import-sources` rebuild enforce that none of
these five snapshots can be restored. The resulting historical C
inventory contains **585 preserved sources and 94 deleted inapplicable
originals**, but still records all **679 original identities**.

## Forty-two deferred source-level oracles

The 42 deferred originals are retained unchanged for a future driver or
compiler profile that can exercise their **actual original assertion**.
The TSV records each individually, including source hash, action,
options, PDP-10 rationale, KCC rationale and limitations.

* **Traditional CPP and diagnostics:** `sysmac1.c`/`sysmac2.c` and
  `tr-*` sources require exact `-traditional`, `-traditional-cpp`,
  `-Wtraditional`, `-pedantic`, warnings suppressed in system headers,
  output checks or explicit `-ansi` trigraph conversion.
  `tr-define.c` is especially vacuous without its two `-D` flags.
  `trigraphs.c` has runtime assertions but its `-ansi` flag is
  essential to phase-one trigraph translation and cannot simply be
  discarded to make a pending runtime test.
* **Character sign and encoding:** `uchar-1.c` through `uchar-3.c`
  depend on `-funsigned-char`, `-fsigned-char`, and/or
  `-fpreprocessed`. `ucs.c` has deliberate invalid universal
  character escapes and required diagnostics, plus target-dependent
  wchar widths. `widestr1.c` requires two explicit invalid-directive
  errors. These are not positive compile tests.
* **Negative preprocessor tests:** `unc1.c` through `unc4.c` require
  errors for unterminated conditionals with precise absence checks;
  `undef2.c` requires five warnings when protected predefined macros
  are undefined. Their failure diagnostics must not be discarded.
* **Debug information:** `gcc.dg/debug/20000503-1.c`,
  `20010207-1.c`, `20011223-1.c`, `20020104-2.c`,
  `20020220-1.c`, `20020224-1.c`, `20020327-1.c`, `debug-1.c`
  through `debug-6.c`, `dwarf2-1.c`, `dwarf2-2.c` and `trivial.c`
  exercise DWARF/lexical-scope generation, debugger-enabled inlining,
  link mode, `-dA` annotated-assembly `scan-assembler` predicates,
  and GNU nested functions/complex values. A plain successful C
  compile (or a trivial main) would omit these debugger-specific
  assertions. The four same-name central testkit candidates are
  **different source bodies**, not equivalent coverage.
* **C declarations and warning diagnostics:** `decl-1.c` must avoid
  two bogus incompatible-pointer warnings when typedef names can be
  parsed as parameters; `deprecated.c` requires numerous exact
  `-Wdeprecated-declarations` warnings, and `divbyzero.c` distinguishes
  required integer divide-by-zero warnings from suppressed checks in
  other expressions. Ordinary compilation is not the original oracle.

## Verification and continuation

`tools/inventory-gcc-unmirrored-v1.py` now checks the exact next
50 identities, original SHA256 fingerprints, three exclusive source
owners, all GCC-only pending profiles, 42 deferred contracts, five
newly inapplicable statuses, and version-2 tombstones retaining the
original 89-row version-1 manifest. The structural-overlap index has
been refreshed against **585 retained C originals** and has **101
potential source-shape leads**; these are token-similarity hints,
not equivalent compiler assertions.

After batch 10, **155 historical original source reviews remain**:
**150 unreviewed** and **five same-name candidates**. Batch 11 should
continue with the next 50 unresolved source identities, preserving
original assertions and independently assessing KCC eligibility.

**Only source, byte/hash, matrix, ownership, deletion and documentation
checks were performed. No compiler, assembler, linker, emulator,
simulator or runtime tests were executed.**
