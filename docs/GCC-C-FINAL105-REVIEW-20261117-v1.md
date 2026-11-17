# Historical GCC C source review, final 105 (2026-11-17 v1)

## Completion and source provenance

All **105 previously unresolved** historical GCC C sources were reviewed
individually against their actual archived bodies, DejaGNU directives,
original test assertions, and 36-bit/9-bit PDP-10 constraints. This
completes the assertion-level review of the full **679-source** preflight.
The pinned original GCC revision remains
`b0f5374f6d4462bb8759160ece635e306d90998f`.

Three versioned, source-ordered decision tables preserve the exact
original source path/SHA256, native action, original options, assertion,
positive/negative diagnostic counts, original target restrictions,
PDP-10 compatibility, independent KCC eligibility, adapted source
owner (if any), exact matrix profiles, and caveats:

| Review | Sources | New pending tests | Deferred | Inapplicable |
| --- | ---: | ---: | ---: | ---: |
| `docs/GCC-C-BATCH12-20261117-v1.tsv` | 50 | 3 | 25 | 22 |
| `docs/GCC-C-BATCH13-20261117-v1.tsv` | 50 | 7 | 40 | 3 |
| `docs/GCC-C-BATCH14-20261117-v1.tsv` | 5 | 0 | 5 | 0 |
| **Total** | **105** | **10** | **70** | **25** |

The ten pending source owners contain **seven runtime** and **three
compile-only** tests. Two compile-only tests have meaningful KCC
coverage; the other eight are GCC-only. The matrix gains **31 pending
GCC PDP-6 cells** and **four pending KCC PDP-6 cells**. All other
compiler/CPU cells for these ten owners are `no_test`.

No compiler, assembler, linker, emulator, simulator, benchmark or guest
runtime test was executed. A pending cell is not a measured pass.

## Ten pending source owners (original bytes retained)

| Original source | Active test and original oracle | Scope |
| --- | --- | --- |
| `gcc.dg/gnu89-init-1.c` | `tests/semantic/gcc-historical-b12-v1/gnu89-init-1.c` -- runtime GNU89 static compound literal/range initializer guards, including array dimensions | GCC-only; original `-std=gnu89` mode not selected by generic GCC profiles |
| `gcc.dg/gnu99-init-1.c` | `tests/semantic/gcc-historical-b12-v1/gnu99-init-1.c` -- runtime GNU99 nested designated range initializer, override and `memcmp`/zero-fill guards | GCC-only; original `-std=gnu99` mode not separately selected |
| `gcc.dg/special/alias-1.c` | `tests/semantic/gcc-historical-b12-v1/alias-1.c` -- verify that `foo` links as `bar` alias and `main` can call it | GCC-only; native runtime **strengthens** original link-only action |
| `gcc.dg/special/alias-2.c` | `tests/semantic/gcc-historical-b13-v1/alias-2.c` -- static alias of `foo` exits successfully rather than falling through `abort()` | GCC-only |
| `gcc.dg/special/wkali-1.c` | `tests/semantic/gcc-historical-b13-v1/wkali-1.c` -- weak alias to `bar`, with successful runtime alias call | GCC-only; runtime strengthens original link-only action |
| `gcc.dg/struct-alias-1.c` | `tests/semantic/gcc-historical-b13-v1/struct-alias-1.c` -- at `-O2`, optimize away unreachable `link_error` and return successfully | GCC-only, `-O2` cell only; runtime strengthens original link-only action |
| `gcc.dg/struct-by-value-1.c` | `tests/semantic/gcc-historical-b13-v1/struct-by-value-1.c` -- run all 64 sizes of structs holding 0 through 63 unsigned 9-bit chars, including nested by-value calls | GCC-only, `-O2` cell only; zero-length-array extension not verified for KCC |
| `gcc.dg/ultrasp1.c` | `tests/codegen/gcc-historical-b13-v1/ultrasp1.c` -- compile signed long-long multiplication/negation and return conversion | GCC and KCC (four GCC and two KCC cells), compiler-only; **no** 64-bit runtime property asserted |
| `gcc.dg/ultrasp2.c` | `tests/codegen/gcc-historical-b13-v1/ultrasp2.c` -- compile cast of integer shift to signed `short` | GCC and KCC (four GCC and two KCC cells), compiler-only; PDP-10 short is not presumed to be a 16-bit short |
| `gcc.dg/ultrasp4.c` | `tests/codegen/gcc-historical-b13-v1/ultrasp4.c` -- compile pointer arithmetic and modulo expression under optimization | GCC-only, `-O2` cell only; not a claim about UltraSPARC `-m64` backend behavior |

Every registered source is a **byte-identical copy of its original**.
The source verifier requires matching SHA256 and unique ownership.
For `alias-1.c`, `wkali-1.c`, and `struct-alias-1.c` the original
`dg-do link` action is strengthened by executing already-present
runtime assertions; this is explicitly recorded in the per-source
review, rather than misrepresented as original run-only coverage.
The tests intentionally retain their historical GNU extension use.

## Twenty-five inapplicable originals removed

The source files deleted in batches 12 and 13 are tied to foreign
instruction sets, operating-system-specific pragmas, or incompatible
object formats/ABIs. Deleting the snapshot is **not** deleting the
historical source identity, original SHA256, or per-source rationale.

| Foreign contract | Deleted originals |
| --- | --- |
| x86 x87, MMX and SSE ISA | `i386-387-1.c`, `i386-387-2.c`, `i386-mmx-1.c`, `i386-mmx-2.c`, `i386-sse-1.c`, `i386-sse-2.c`, `i386-sse-3.c` |
| IA64 instructions, intrinsics and GP relocations | `ia64-asm-1.c`, `ia64-sync-1.c`, `ia64-sync-2.c`, `ia64-visibility-1.c` |
| PPC/SPARC/MMIX backend assembly and ABI | `iftrap-1.c`, `mmix-1.c`, `ppc-ldstruct.c`, `sparc-ret.c`, `splet-1.c`, `struct-ret-1.c`, `switch-1.c` |
| Native pragma and loader ABI | `pragma-align.c`, `pragma-darwin.c`, `pragma-ep-1.c`, `pragma-ep-2.c`, `pragma-ep-3.c`, `pragma-re-1.c`, `pragma-re-2.c` |

Each original target guard was examined before deletion, including
native assembler `dg-final` patterns, `-mmmx`, `-msse`, `-mfpmath=387`,
`-mtoplevel-symbols`, IA64 inline-assembly/atomic instructions,
Mac68k/Solaris/OSF symbol-pragmas, HPPA struct-return ABI and
PowerPC/SPARC PIC or return-delay-slot assumptions. These contracts
cannot be turned into PDP-10 regressions without replacing their
original machine-level assertion. The unchanged 94 earlier tombstones
are followed by exactly these 25 entries in the version-3 manifest:
`docs/GCC-C-INAPPLICABLE-REMOVALS-20261117-v3.tsv`.

The companion removal explanation is
`docs/GCC-C-INAPPLICABLE-REMOVALS-REVIEW-20261117-v3.md`.
The source inventory now retains **560 historical C source snapshots**
and tracks **119 deleted inapplicable originals**. The full ledger and
preflight still enumerate **all 679 original identities**, with their
SHA256 fingerprints. All 25 archived local include companions remain.

## Seventy retained, deferred assertions

The source-by-source TSVs supply the detailed, individual assertions
and limitations. The main reasons for remaining inactive are:

* **PDP-10 assembler regressions: highest compiler priority.**
  `pdp10-local-char-word-boundary-1.c` and
  `pdp10-lshr-subreg-plus-1.c` are preserved. The first requires
  exact `POINT 9,(17),8` and forbids `POINT 9,(17),17` for the fifth
  9-bit local byte. The second requires the `subi` shift-count form
  and forbids `lsh ... -036(index)`. These two original targets are
  directly relevant to the PDP-10 compiler, but **ordinary successful
  compilation does not evaluate their `scan-assembler` predicates**.
  Register them only when the testkit can actually run the exact
  assembler scan or equivalent checked assembly oracle.
* **Diagnostic correctness and absence.** `format/va-1.c` through
  `format/z-1.c`, `ifelse-1.c`, `m-un-*`, `noreturn-*`, `qual-return-*`,
  `return-type-*`, `sequence-pt-1.c`, `setjmp-1.c`, `uninit-*`,
  `unused-*`, `va-arg-1.c`, `vla-init-1.c`, `unordered-1.c`, and
  `wtr-*` require particular `dg-warning`, `dg-error` or `dg-bogus`
  outcomes and flags such as `-Wuninitialized`, `-Wtraditional`,
  `-Wsequence-point`, `-Wall`, `-pedantic` and `-Wreturn-type`.
  Many explicitly test suppression in `#line`-marked system headers.
  They cannot be represented by a generic positive compile-only cell.
* **Multiple translation units and linker semantics.**
  `special/weak-1.c`, `weak-1a.c`, `weak-2.c`, `weak-2a.c`, `weak-2b.c`,
  `wkali-2.c`, `wkali-2a.c` and `wkali-2b.c` are a set of
  primary/secondary C translation units: the linker must choose the
  strong `foo` over the weak `foo`. Their helper files are **not
  standalone tests**. `special/gcsec-1.c` requires a section-garbage
  collection linker mode. No helper was deleted or spuriously
  registered without its original link graph.
* **Architecture-neutral candidates needing additional review.**
  `pack-test-1.c` and `pack-test-2.c` need actual `#pragma pack`
  compatibility and byte-alignment validation using the existing
  historical `pack-test-1.h`, and the latter needs negative
  diagnostics. `ultrasp3.c` has hardcoded 64-bit multiplication
  results unsuitable for unmodified PDP-10 long long. `struct-ret-2.c`
  requires `-O3 -w`. `inline-1.c`, `inline-2.c`, and `weak-1.c`
  require original assembly-output checking, not source acceptance.
  `wchar_t-1.c` and `wint_t-1.c` need the native system header and
  warning absence checks.

The four remaining same-name overlaps were reviewed individually:
`struct-ret-1.c`, `struct-ret-2.c`, `va-arg-1.c`, and
`wchar_t-1.c`. A shared basename is never treated as equivalent
test coverage without identical assertion and source behavior.

## Static validation and complete handoff

`tools/inventory-gcc-unmirrored-v1.py` validates all three last
source batches (50/50/5), each original SHA256 and individual
classification, each of the ten copied pending sources, approved
GCC/KCC optimization cells and isolation of all deferred originals.
It checks the new 119-row deletion manifest against the exact
**94-row v2** and **89-row v1** prefixes, the full 679-source
preflight ledger, 560 retained source hashes and 25 preserved
include companions. An explicit `--import-sources` never revives
removed sources. The six-token structural comparison is refreshed
for 560 retained originals and has 111 **shape-only** hints, not
assertion equivalence proofs.

**No original GCC C source remains unreviewed or pending a same-name
source-identity decision in the 679-source corpus.** This closes the
source-review task, **not** execution, debugger-output, linker-mode,
warning-diagnostic, or optimization-result verification. Those
separate tests remain pending/deferred under their recorded oracles.
