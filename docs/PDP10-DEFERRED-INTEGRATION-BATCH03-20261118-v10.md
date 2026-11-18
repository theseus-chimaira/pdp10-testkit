# Deferred integration: third ten-source batch (2026-11-18, v10)

## Scope

This batch reviews exactly ten previously **unreviewed** source identities
from the 253-row `SEMANTIC-DEFERRED-DISPOSITION-20261118-v3.tsv`,
excluding paths present in the earlier first-ten v8 and next-ten v9
review ledgers. The historical source files and assertions were not
modified; all test results come from the installed KCC/GCC, real
freestanding libc where needed, assembler/linker and PDP-6 simulator.

No full compiler matrix, other CPU targets, DAIMOS guest tests or any
of the 44 manually registered special cases were run. Compiler failures
were recorded for the eventual full compiler sweep rather than repaired
during this harness review. **No source was deleted**.

The ten-row `PDP10-DEFERRED-INTEGRATION-BATCH03-20261118-v10.tsv`
pins each source SHA256, original disposition, actual PDP-6 KCC and
GCC outcomes at the executed optimization levels, registration status
and decision reason.

Current authoritative inventory:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v5.tsv`:
  **471 active, 246 deferred, 56 removed, one stress-nonportable**;
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v4.tsv`:
  **246 outstanding SHA256-matched deferred sources**;
- `COMPILER_MATRIX.tsv`: **2,130 source identities**; seven added in
  this batch without duplicate matrix registration.

## Ten source decisions

| Source | Decision | PDP-6 evidence and scope |
| --- | --- | --- |
| `20010605-2.c` | Connect GCC | Real and imaginary parts of complex float, double and long double are passed to `foo`, `bar`, `baz` and checked against expected values by `abort`. GCC `-O0/-O1/-O2/-Os` **4/4 pass**. KCC GNU complex syntax rejected. |
| `20010904-1.c` | **Retain deferred** | `aligned(32)` aggregate-array stride is checked by a real modulo-32 `abort` assertion. GCC `-O0` **runtime fails**; KCC cannot compile GNU aligned attribute. Critically, installed GCC predefines `__PDP10__`, **not** lowercase `__pdp10__`; the source's `#ifndef __pdp10__` consequently **enables**, not disables, the alignment test. Old `nonasserting` classification was incorrect. |
| `20010904-2.c` | **Retain deferred** | Second aligned(32) array-of-struct layout uses a different member arrangement but the same real byte-stride assertion; GCC `-O0` **runtime fails**. KCC compile fails. Its old `nonasserting` classification was likewise incorrect. |
| `20010915-1.c` | Connect KCC/GCC with failing optimized GCC profiles | Real argv/loop checks in `main` assert `check == 2` and `o == 5`; the `r` helper checks the successive characters b/c/d/e. KCC `-n/opt` **2/2 pass**; GCC `-O0` passes, but `-O1/-O2/-Os` **runtime fail**. The original `abort;` in `s` is only a no-effect expression, not a working `strcmp` failure assertion. We retain the meaningful remaining loop/count oracle and document that limitation explicitly. |
| `20010924-1.c` | **Retain deferred** | The source asserts characters in GNU flexible-array string and brace initializers. KCC rejects the extension; GCC `-O0` executes but **runtime fails**. The original assertions are valid as a GNU extension regression and are not weakened or deleted. |
| `20010925-1.c` | Connect narrowly, KCC/GCC | `main` asserts `foo(dst,src,10)==0` on the nonzero-size path following a call to real `memcpy`. KCC `-n/opt` **2/2 pass** and GCC `-O0/-O1/-O2/-Os` **4/4 pass**. **It does not verify copied bytes**; this is control-flow/call coverage, not a `memcpy` content-correctness test. |
| `20011008-3.c` | Connect KCC/GCC | A large local `DB_LSN` array, union-member pointers, nested transaction-list loops and return checks assert exactly 1 and `VLEN-1`. KCC `-n/opt` **2/2 pass** and GCC all four optimizations **4/4 pass**. No extra stack/CPU profiles assumed. |
| `20011024-1.c` | Connect GCC with optimized failures | Tests a `pure` `strcmp` potentially reading global memory, `strlen`, real `memcpy`, pointer identity and zero/nonzero comparisons. GCC `-O0` passes; `-O1/-O2/-Os` **runtime fail**. KCC rejects GNU syntax. The optimizer failures are explicitly registered, not marked as successful. |
| `20011113-1.c` | Connect GCC; reconcile duplicate | Real `memcpy` into a three-long aggregate, followed by by-value `U` argument passing to `bar`, which asserts values 21/22/23. GCC all four optimizations **4/4 pass**. KCC rejects GNU `restrict`/`__SIZE_TYPE__`. Its byte-identical PDP-10 copy stays separately deferred. |
| `20011121-1.c` | Connect GCC | `__builtin_memcpy` of a prefix-sized structure must preserve the following member `s2.b[0]==100` or `abort`. GCC all four optimizations **4/4 pass**. KCC's unresolved builtin linker error remains recorded for the later compiler sweep. |

The first three retained sources above preserve real unsatisfied
oracles. **None is eligible for deletion on the present evidence**.
The two `20010904` cases and flexible-array initializer case were
reclassified as `compiler-investigate` in the new deferred
manifest, with their actual source-level assertions and PDP-6 failure
evidence rather than the stale `nonasserting`/feature-only labels.

## Bounded execution results

The first phase executed exactly **20 cells**: ten source identities
at KCC PDP-6 native `-n` and GCC PDP-6 native `-O0`. The second
phase tested the seven GCC `-O0` passing sources at `-O1/-O2/-Os`,
**21 cells**, of which 15 pass and six fail in the two cases above.
The third phase ran the three KCC `-n` passing sources with KCC
optimization, **3/3 pass**. Total: **44 targeted executions**.

The seven newly connected matrix sources have exactly **28 GCC
PDP-6 source/profile slots**: 22 passing, six recorded failing.
Three KCC PDP-6 native source slots pass in both optimized and
unoptimized modes: six **passing** runner cells. A fourth KCC
source slot, `20011121-1.c`, is explicitly registered as
`error` for both modes because the unchanged source has a real
unresolved builtin linker defect; these two scheduled **failure**
cells are not counted as passes. In total the seven new source rows
contribute **28 GCC and eight KCC** selected PDP-6 cells: 28
passing profiles and **eight recorded failing** profiles (six
GCC optimized runtime failures and two KCC builtin link errors).
Other CPU/target-family profiles remain pending or unsupported, and
unexecuted profiles are not represented as passing.

Real per-cell logs remain in:

- `$TMPDIR/p10tk-deferred-integration-batch03-20261118-v10`
- `$TMPDIR/p10tk-deferred-integration-batch03-gccopts-20261118-v10`
- `$TMPDIR/p10tk-deferred-integration-batch03-kccopts-20261118-v10`

## Identical source and owner reconciliation

`tests/todo/generic/20011113-1.c` is byte-for-byte identical to
`tests/todo/generic/pdp10/20011113-1.c`. The prior 50-pair
inventory classified both as deferred with distinct legacy
`libc-linkage` and `feature-policy-decision` blockers. That
collision cannot be silently ignored after promotion.

`DEFERRED-SOURCE-DUPLICATES-20261118-v4.tsv` and
`DEFERRED-SOURCE-DUPLICATES-20261118-v5.tsv` retain the 50 source
identities and SHA256 pins, updating only this pair:

- Generic source is now the active, actually executed GCC owner.
- Byte-identical PDP-10 source remains deferred for the KCC GNU
  syntax/feature-policy limitation, without a second matrix entry.
- Historical divergent dispositions are explicitly retained in
  preceding immutable versions and the new review evidence.

The fail-closed duplicate auditor accepts the active/deferred
ownership with a matching KCC-specific independent gate. Its current
counts are **four active/deferred pairs**, **five distinct unresolved
disposition conflicts**, all **50 reviewed**, zero unowned pairs.

## Next group

For batch 4, choose the next **ten still-deferred identities not
already listed in the v8, v9 or v10 ten-source ledgers**. Begin with
`tests/semantic/upstream/inline-asm/20020107-1.c`, followed by
`20020108-1.c`, `20020219-1.c`, etc. Do not revisit the six
previously reviewed but necessarily still-deferred sources as if
they were unreviewed. Review every original assertion and explain
any proposed deletion *before* deleting the file. The 44 manual
special cases and full compiler matrix remain out of scope.
