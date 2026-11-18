# Deferred integration: seventh ten-source batch (2026-11-18, v14)

## Scope

Exactly ten previously unreviewed deferred sources, in the original
ordering of `SEMANTIC-DEFERRED-DISPOSITION-20261118-v7.tsv`, after
excluding the six previous ten-source ledgers (v8-v13).
Only narrow PDP-6 KCC/GCC checks and scratch investigations were run;
there was no full compiler matrix, no DAIMOS guest test, no other
CPU sweep, and no execution of the 44 manual special tests.

**Eight source identities connected, two retained deferred, zero
deleted.** No compiler or installed runtime was changed. One original
source needed only the previously validated target-macro spelling
adaptation; its mathematical assertion was left unchanged.

Authoritative current state:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v9.tsv`:
  **496 active / 221 deferred / 56 removed / 1 nonportable stress**;
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v8.tsv`:
  **221** SHA256-pinned outstanding sources;
- `COMPILER_MATRIX.tsv`: **2,155** unique compiler sources, with
  eight new rows.
- `PDP10-DEFERRED-INTEGRATION-BATCH07-20261118-v14.tsv`:
  original and current SHA256, historical disposition, exact
  KCC/GCC results by tested optimization, and the decision for
  each of the ten sources.

## Per-source decisions

| Test | Decision | What was actually established |
| --- | --- | --- |
| `920908-2.c` | **Connect KCC and GCC after minimal source adaptation** | The 24-bit bitfield `c=0xffff11` is converted to PDP-10 9-bit `char`; `f(t)` must equal the existing PDP-10-specific expected value `0x111`. The original `#ifdef __pdp10__` missed both installed compilers' `__PDP10__`, so they previously selected the wrong 8-bit expectation and both failed. A scratch `-D__pdp10__` test passed GCC O0/O1 and KCC noopt/opt. Recognizing either spelling in the actual source, without altering expected values or abort, passed GCC O0/O1/O2/Os and KCC noopt/opt. |
| `920909-1.c` | **Connect GCC, narrow default-case only** | `f(1)` is outside all six switch cases `0x402..0x407`; main aborts unless it returns zero. GCC PDP-6 O0/O1/O2/Os pass. Generated O0/O2 code actually checks out-of-range input and reaches the default. **No explicit switch case is called**, so case-table or case-body correctness is not claimed. KCC noopt encounters a Dlink RH18 relocation/link failure; leave it as toolchain error, not an invented compiler runtime error. |
| `921007-1.c` | **Retain deferred** | Original `__builtin_strcmp("X","X\\376")` must return a value less than zero, otherwise abort. GCC PDP-6 O0 executes but **runtime fails**. KCC noopt fails linkage on its unlowered `__builtin_strcmp`. The nontrivial 9-bit comparison remains useful; no fake builtin implementation or altered assertion. |
| `921017-1.c` | **Connect GCC** | GNU nested `g(i)` captures VLA `a[n]`; `f(2)` stores 4711 at index 1 and reads it from the nested function; main aborts unless it returns 4711. GCC PDP-6 O0/O1/O2/Os pass; generated O0/O2 retain VLA stack adjustment, nested call, and explicit comparison. KCC does not support GNU nested functions. |
| `921029-1.c` | **Connect GCC** | `build(h,l)` constructs and returns an unsigned wide integer from two explicit **32-bit source-level bit patterns** and checks **12 different combinations** against exact long-long constants. GCC PDP-6 O0/O1/O2/Os pass. These are not claims about physical PDP-10 18-bit halves. KCC noopt **runtime fails**; preserve for later compiler analysis. |
| `921117-1.c` | **Connect with GCC optimization failures** | Real freestanding `strcpy` fills an 11-byte text field and the struct is passed by value to `check`, which verifies flag 99 and compares text to `0123456789` through real `strcmp`. GCC PDP-6 O0 **passes**, O1/O2/Os **runtime fail**. KCC noopt **passes**, but optimized KCC compilation emits an unresolved `strcmp` at link time. The single native KCC matrix field is conservatively `error` for both KCC modes; the distinct observed statuses are in the v14 ledger. No assertion or linkage workaround changed. |
| `921202-2.c` | **Connect GCC** | Original long-long `0x0123456789ABCDEF`, shifted right eight bits then masked by `0xff`, must return `0xCD` or abort. GCC PDP-6 O0/O1/O2/Os pass with the actual wide shift and comparison. KCC noopt **runtime fails**. |
| `921215-1.c` | **Retain deferred** | GNU nested functions `p/q/r` construct and invoke trampolines to reach `foo`. GCC PDP-6 O0 **passes** and O0 assembly contains indirect calls, but the original `foo` is empty and main has **no explicit callback-reached or value assertion**. GCC O1/O2/Os **runtime fail**; KCC cannot parse GNU nested functions. The O0 exit is therefore not sufficient evidence of a successful callback test. Retain for later focused assertion strengthening and compiler-trampoline investigation, not as a passing current matrix test. |
| `930106-1.c` | **Connect GCC with optimization caveat** | By default the source declares 399,999 9-bit characters on stack, calls `g()` three times and aborts unless floating-point sum is 3.0. GCC PDP-6 O0/O1/O2/Os pass. O0 assembly actually adjusts the stack by about **100,000 words**; higher optimizations may eliminate the *unused* large `dummy` array. Therefore only O0 proves the stack-allocation aspect; optimized modes prove the retained floating arithmetic/return assertion. KCC noopt **runtime fails**. |
| `930111-1.c` | **Connect GCC; record KCC ICE** | A 71-bit long-long switch receives value zero; `wwrite(0)` must take the default and return 123 or main aborts. GCC PDP-6 O0/O1/O2/Os pass. None of the five explicitly listed positive switch cases is called, so only default dispatch is verified. KCC noopt reports **internal compiler error `sizetype: null type` at `wwrite`**, not a syntax or runtime failure. Defer compiler repair until the later full sweep and retain its byte-identical PDP-10 source. |

The two retained sources **should not be deleted**: `921007-1.c`
has a genuine semantic/builtin comparison failure, while
`921215-1.c` has a real trampoline execution problem and an
insufficient original success oracle. No source deletion or
test-only substitute was performed.

## Target macro adaptation

The only source edit was in `tests/todo/generic/920908-2.c`:

```c
#if defined(__PDP10__) || defined(__pdp10__)
```

The bitfield packing, char conversion, original expected `0x111`,
and abort branch are unchanged. Both original and adapted source
SHA256 digests are preserved in the v14 ledger, and the original
source remains recoverable from the parent Git revision. Macro
branch tests were performed **before** promoting the source.

## Bounded validation and matrix registration

- Original baseline: ten sources, KCC PDP-6 noopt and GCC O0,
  **20 cells**. `920908-2.c` initially failed both, as it selected
  the wrong expectation.
- Eight initially GCC-O0-passing sources at O1/O2/Os,
  **24 cells**. The only optimizer failures were all three
  optimized `921117-1.c` modes and all three optimized
  `921215-1.c` modes. The latter was not registered.
- Scratch-only macro correction: GCC O0/O1 and KCC noopt/opt
  **4 passing checks** on the original source with target define.
- Corrected source without added flags: KCC noopt, GCC O0,
  GCC O1/O2/Os, KCC opt: **6 passing checks**.
- Independent KCC optimized `921117-1.c`: **one link failure**
  on unresolved `strcmp`, recorded separately from its KCC
  noopt success.

The eight connected matrix sources contribute **32 GCC PDP-6
native slots**: 29 verified passes and three explicit optimized
runtime failures. KCC's single per-CPU native matrix status spans
both optimization modes, producing **14 selected KCC PDP-6 slots**:
two passing slots on corrected `920908-2.c`, six conservatively
`fail`, and six conservatively `error`. The KCC ledger
distinguishes observed noopt successes, link failures and the
`930111-1.c` ICE from modes never independently executed.
Other CPU/target-family cells remain pending or unsupported.

Versioned local diagnostic directories:

- `$TMPDIR/p10tk-deferred-integration-batch07-20261118-v14`
- `$TMPDIR/p10tk-deferred-integration-batch07-gccopts-20261118-v14`
- `$TMPDIR/p10tk-deferred-integration-batch07-macro-20261118-v14`
- `$TMPDIR/p10tk-batch07-920908-postedit-20261118-v14`
- `$TMPDIR/p10tk-batch07-postedit-opt-20261118-v14`

## Duplicate sources and next cursor

Three promoted originals have byte-identical deferred PDP-10 copies:
`920909-1.c`, `930106-1.c` and `930111-1.c`. The v12 duplicate
census and v13 review preserve **all 50 SHA256 source pairs**,
reconciling exactly these three to active generic GCC owners and
deferred PDP-10 KCC-specific blockers. This creates **nine
active/deferred pairs** and leaves **six other disposition conflicts**,
with zero unowned or doubly scheduled tests. The KCC evidence is
respectively a Dlink RH18 error, a runtime mismatch, and a
compiler ICE. No duplicate source was removed.

For batch 8, select **ten distinct not-yet-reviewed deferred sources**
from `SEMANTIC-DEFERRED-DISPOSITION-20261118-v8.tsv`, excluding
all v8-v14 ten-source review ledgers. The first eligible source is
`tests/todo/generic/930126-1.c`. The 44 manual special tests,
compiler repairs, and full compiler matrix remain on hold. Explain
any proposed deletion **before** removing the file.
