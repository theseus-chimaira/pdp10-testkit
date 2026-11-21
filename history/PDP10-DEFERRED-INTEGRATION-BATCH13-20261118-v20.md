# Deferred integration: thirteenth ten-source batch (2026-11-18, v20)

## Scope and outcome

Select exactly ten previously unreviewed source identities in order
from `SEMANTIC-DEFERRED-DISPOSITION-20261118-v13.tsv`, excluding
the twelve v8-v19 ten-source review ledgers. Review each original
assertion, then run only bounded PDP-6 native KCC and GCC cells.
Do not run the full compiler/CPU matrix, guest DAIMOS operating-system
tests, or any of the 44 manually gated special tests.

**Five connected, five retained deferred, none deleted or edited.**
The ten-source `PDP10-DEFERRED-INTEGRATION-BATCH13-20261118-v20.tsv`
preserves exact original/current SHA256 hashes (unchanged), actual
KCC/GCC PDP-6 execution outcomes at each tested optimization level,
the matrix registrations, and the original-assertion decision.

Current authoritative inventory:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v15.tsv`:
  **531 active / 184 deferred / 58 removed / 1 stress-nonportable**;
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v14.tsv`:
  **184** currently deferred SHA256-pinned sources;
- `COMPILER_MATRIX.tsv`: **2,190** unique compiler sources,
  including five newly integrated GCC source owners;
- `DEFERRED-SOURCE-DUPLICATES-20261118-v18.tsv` census and
  `DEFERRED-SOURCE-DUPLICATES-20261118-v19.tsv` review:
  all **50** source pairs remain byte-identical. Exactly five
  original-source pairs become active-GCC/deferred-KCC pairs,
  with no second matrix registration, including two cases where
  the canonical active source is the **B** side of the pair.

Earlier classified/deferred/duplicate manifests remain historical
snapshots, not silently revised records.

## Per-source decisions

| Source | Decision | Original assertion and verified limitations |
| --- | --- | --- |
| `align-1.c` | **Retain deferred** | The source declares an `int` typedef with GNU `aligned(16)`, **but never uses that typedef**. Its sole assertion is unrelated: `sizeof(struct S)==sizeof(int)` for a structure containing one `int`. GCC PDP-6 O0/O1/O2/Os exits pass with folded size arithmetic; the emitted O0 `main` is only a return. This **does not test alignment**. KCC does not accept the attribute. Do not promote an unrelated struct-size fact as an alignment regression; preserve for a future actual alignment assertion. |
| `arith-ll.c` | **Retain deferred** | Fifteen exact signed-long-long operand pairs are checked by separate addition, subtraction, multiplication and division functions. On a mismatch, the source calls real **variadic `printf`** before incrementing failures and ultimately aborting. Both GCC PDP-6 O0 and KCC noopt **link fail** on the real hosted diagnostic prerequisite. Do not substitute a fake formatter or delete its ABI behavior. |
| `arith-rand.c` | **Retain deferred** | The 1,000-iteration random arithmetic oracle checks quotient/remainder recomposition for unsigned/signed integers, shorts and characters. The random generator uses **`8*sizeof(long)`** as its bit-width cutoff, incompatible with native **9-bit bytes**. Signed short/char division also lacks an explicit zero-divisor guard. GCC O0 and KCC noopt both **runtime fail**. A target-correct width and divisor policy must be derived before claiming either source correctness or compiler failure; preserve the original test. |
| `ashldi-1.c` | **Connect GCC** | The source already selects **`__LONG_LONG_71BIT__`** and a PDP-10-specific 71-entry unsigned-long-long reference table. Two complete loops compare variable shifts and constant shifts by 0..70 against each expected value, aborting on mismatch. GCC PDP-6 O0/O1/O2/Os **4/4 pass**, preserving real reference checks. KCC noopt does not compile the wide-int source; KCC matrix profiles remain `no_test`. Its byte-identical PDP-10 copy remains deferred. |
| `ashrdi-1.c` | **Connect GCC** | The source already contains 71-bit positive (`zext`) and negative (`sext`) right-shift reference tables. Four loops compare variable and constant signed-long-long shifts by 0..70 against all positive and negative expected values, including sign propagation. GCC PDP-6 O0/O1/O2/Os **4/4 pass**. KCC noopt rejects the source; its byte-identical PDP-10 copy remains deferred. These are actual wide-shift regressions, not type-width assumptions to be rewritten. |
| `bcp-1.c` | **Connect GCC; preserve KCC internal compiler error** | Function-pointer tables invoke `bad0..bad10` whose `__builtin_constant_p` must be false, `good0..good2` whose results must be true, and, under `__OPTIMIZE__`, `opt0..opt2` whose results must also be true. The original abort paths remain reachable. GCC PDP-6 O0/O1/O2/Os **4/4 pass**. **Only O1/O2/Os execute the optimization-specific assertions**; O0 tests the base cases. KCC noopt reports multiple **internal `dodecl: scope mismatch` errors** and further diagnostics, not a passing run. Preserve KCC evidence and retain its byte-identical PDP-10 copy deferred without double registration. |
| `bf-layout-1.c` | **Connect GCC with narrow size oracle** | The original asserts `sizeof(a)==sizeof(b)`, with `a` containing `long f8:8; long f24:24` and `b` containing `long f32:32`. GCC PDP-6 O0/O1/O2/Os **4/4 pass** with constant-folded equality; both fit the current 36-bit word as four native 9-bit character units. **Neither field content nor bit order is read back**, so do not claim full packing correctness. KCC rejects nonstandard long bitfields and the identical PDP-10 copy remains deferred. |
| `bf-pack-1.c` | **Connect as an all-failing GCC packed-bitfield regression** | GNU `packed` `unsigned long whole:32` follows `unsigned half:16`. The test assigns `0x1234` and `0x56789abcL`, then `f` reads back **both fields** and aborts if either mismatches. GCC PDP-6 O0/O1/O2/Os **4/4 runtime fail**; O0 assembly contains real comparisons and aborts. All four GCC modes are registered **`fail`**, not passing. KCC rejects the extension; its identical PDP-10 source remains deferred for that independent compiler prerequisite. |
| `bf-sign-2.c` | **Retain deferred** | The original promotes several signed and unsigned 3/15/31/32/35-bit bitfields and tests signs after subtracting two. It assumes that unsigned 32-bit and 35-bit fields cannot promote to signed `int`, but PDP-10 native `int` is **36 bits**. Thus the asserted unsigned/signed comparisons are not independent of the source's original 32-bit promotion model. GCC O0 **runtime fails**, KCC noopt rejects the nonstandard declarations. Derive target-correct promotions before adapting the test or diagnosing the compiler. |
| `bf64-1.c` | **Retain deferred** | Two structures contain a signed 52-bit `long long field` and 12-bit pad in different orders; both copy the structures, OR the field and assert it equals the literal `0xFFFFFF541FFF567FLL`. That fixed mask reflects 64-bit-style sign extension and needs separate validation under native **71-bit signed long long**. GCC PDP-6 O0 **runtime fails**; KCC noopt rejects the long-long bitfields. The original asserted source remains intact for 71-bit investigation. |

All five retained sources retain meaningful historical value,
but none currently supplies a valid aligned-attribute, hosted
runtime, or independently checked target-width success oracle.
No deletion was proposed or performed. No original expected
value, field width, shift table, or source byte was changed.

## Bounded tests and exact matrix results

- Ten unchanged source identities at KCC noopt and GCC O0:
  **20 PDP-6 baseline cells**.
- The five GCC O0 successes plus the failing `bf-pack-1.c`,
  each at O1/O2/Os: **18 PDP-6 optimized cells**.
- **38 bounded PDP-6 checks** in all; no broad sweep.

The five active source owners select exactly **20 native PDP-6
GCC profiles: 16 verified `semantic` passes and four explicit
`fail` profiles** (`bf-pack-1.c`). KCC's existing noopt
failure evidence is preserved separately, including the
`bcp-1.c` internal compiler errors; no KCC profile is
registered as passing or as an independently tested native
optimized run. KCC is `no_test` for these unsupported GNU/wide
bitfield or builtin extensions. Unchecked CPUs/compiler families
remain pending/unsupported.

Versioned local execution evidence:

- `$TMPDIR/p10tk-deferred-integration-batch13-20261118-v20`
- `$TMPDIR/p10tk-deferred-integration-batch13-gccopts-20261118-v20`

## Duplicate sources and next cursor

The promoted `ashldi-1.c` and `ashrdi-1.c` wide-int originals
are **source B** of their respective historical PDP-10-vs-wide-int
duplicate pairs. The promoted `bcp-1.c`, `bf-layout-1.c`,
and `bf-pack-1.c` originals are **source A** in theirs.
The v18 census and v19 review mark precisely these five pairs
active/deferred, identify the active GCC owner regardless of pair
order, and retain the independent KCC blocker. All 50 original
SHA256 pairs are unchanged; no duplicate was deleted.

Batch 14 should select exactly ten **not-yet-reviewed** deferred
identities from
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v14.tsv`, excluding
all v8-v20 ten-source review ledgers, beginning at
`tests/todo/generic/bitfld-2.c`. At this checkpoint,
**140 deferred identities remain unreviewed**, and **44**
already-reviewed identities remain deferred for independently
documented blockers. The 44 manual special tests, ordinary
compiler repairs and full CPU/compiler matrix sweep remain on
hold. Explain the exact source-specific reason **before any
future deletion**.
