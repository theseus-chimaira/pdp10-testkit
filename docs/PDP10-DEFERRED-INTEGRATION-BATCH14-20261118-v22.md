# Deferred integration: fourteenth ten-source batch (2026-11-18, v22)

## Scope, source selection, and disposition

Select precisely the first ten *previously unreviewed physical canonical*
deferred sources in
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v15.tsv`, excluding the
v8-v20 historical source-review ledgers. This is the first batch after
the 97-pair duplicate-source consolidation (v21); retired source aliases
must not be restored, scheduled or counted as new identities.

Review each original source's asserted behavior, run bounded native
PDP-6 KCC noopt and GCC O0 cells, then run GCC O1/O2/Os only on
meaningfully assertive cases. Do not run the broad compiler/CPU matrix,
fix unrelated compiler defects, or execute the 44 manually gated tests.

**Six sources connected, four retained deferred, none edited or
deleted.** The ten-row
`PDP10-DEFERRED-INTEGRATION-BATCH14-20261118-v22.tsv` pins each
original/current SHA256 (identical), previous disposition, exact tested
KCC/GCC PDP-6 results, registered profiles and decision reason.

Authoritative post-batch inventories:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v17.tsv`:
  **490 active, 128 deferred, 58 previously removed, one stress
  nonportable** (677 canonical historical classifications).
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v16.tsv`:
  **128 SHA256-pinned live deferred sources**.
- `COMPILER_MATRIX.tsv`: **2,149** unique test sources, six new
  active GCC PDP-6 registrations.
- The consolidation v21 provenance and its **16 still-open KCC/GCC
  failure gates** are unchanged. The v21 auditor verifies that the
  classified source corpus remains **free of identical-source pairs**.

## Per-source decisions

| Original source | Decision | Original oracle and observed PDP-6 evidence |
| --- | --- | --- |
| `bitfld-2.c` | **Connect GCC with narrow size oracle** | Two structures use `unsigned short` bitfields of widths 5/5/6 and 5/3/8. If native `unsigned short` can represent 65521, abort unless `sizeof(struct A)==sizeof(struct B)`. GCC O0/O1/O2/Os **4/4 pass**. The compiler constant-folds the size comparison, so the result validates the compiler's type-layout calculation, **not** actual packed field contents or bit order. KCC noopt rejects this nonstandard bitfield declaration. |
| `built-in-setjmp.c` | **Connect GCC with optimized failures** | The original allocates a stack string with `__builtin_alloca`, calls actual `strcpy(p,"test")`, saves a nonlocal transfer context with `__builtin_setjmp(buf)`, then calls `__builtin_longjmp(buf,1)` from a noinline helper. On return, its `strcmp(p,"test")` must be zero or `abort`. GCC O0 **passes**, with emitted nonlocal indirect transfer and real string calls; GCC O1/O2/Os each **runtime fail** with `__test_exit=1`, not timeout. Optimized generated code retains the nonlocal branch, while its string operations can be folded. Register **`semantic/fail/fail/fail`**. KCC noopt cannot link the required hosted/string or compatible builtin support; no KCC success inferred. |
| `builtin-abs-1.c` | **Connect GCC** | Volatile runtime inputs and constant-folded operands check standard `abs/labs/llabs/imaxabs` for 0, +/-1 and positive/negative maximum on `int`, `long`, `long long`, and the source-defined `intmax_t`. Wrong runtime results call `abort`; forbidden unevaluated builtin calls and failed constants also lead to abort. GCC O0/O1/O2/Os **4/4 pass**, and O0/O2 assembly contains numerous genuine abort checks. KCC noopt cannot compile the installed `limits.h`/builtin dialect; mark `no_test`, not a passing KCC cell. |
| `builtin-abs-2.c` | **Connect GCC** | As above, but explicitly exercising GNU `__builtin_abs`, `__builtin_labs`, `__builtin_llabs` and `__builtin_imaxabs`; exact volatile and constant extrema checks and abort paths remain unchanged. GCC O0/O1/O2/Os **4/4 pass** with emitted comparisons. KCC noopt cannot compile the GNU-builtins/header combination. |
| `builtin-complex-1.c` | **Connect GCC** | Original `float`, `double`, and `long double _Complex` values `1+2i` exercise `conj/creal/cimag` and matching `__builtin_` variants, for both volatile runtime values and constant-folded expressions. Real/imaginary results must exactly match `1-2i`, 1 and 2 or abort. GCC O0/O1/O2/Os **4/4 pass** and emitted O0/O2 main contains actual complex comparisons and abort branches. KCC noopt rejects GNU complex syntax; no KCC native profile. |
| `builtin-noret-1.c` | **Retain deferred** | The historical noreturn/link-only regression guards calls to functions containing unreachable `link_failure` calls after abort/exit. The lowercase-only `__pdp10__` guard leaves `_eexit(1)` active under the installed uppercase target spelling, causing GCC O0 **link failure**; KCC noopt **compile failure** involving undeclared `_exit`. Simply forcing a pass by eliding the branch would not prove the compiler's noreturn code generation. Preserve the original for a later substantive source/ABI adaptation; do not install a fake symbol or change assertions here. |
| `builtin-prefetch-1.c` | **Retain deferred** | Enumerates legal `__builtin_prefetch` read/write/locality arguments and simply returns `exit(0)`. GCC O0 passes, but PDP-6 has no actual prefetch instruction and this source has **no result, count, or side-effect assertion**. KCC noopt link fails on the unsupported builtin. Do not promote a potential no-op as a verified semantic test. |
| `builtin-prefetch-2.c` | **Retain deferred** | Exercises global, static, local, array and struct-field prefetch address expressions. GCC O0 exits successfully and KCC noopt cannot link the builtin, but **there are no assertions** to tell whether a PDP-6 no-prefetch lowering preserves any meaningful observable operation. Keep the original for compile/codegen-oracle review. |
| `builtin-prefetch-3.c` | **Retain deferred** | Like the previous source, but with volatile pointer/address combinations. GCC O0 passes and KCC noopt link fails; no original assertion checks a volatile access, value, function-call count or side effect. Retain until a grounded non-vacuous target oracle is available. |
| `builtin-prefetch-4.c` | **Connect GCC as real argument-evaluation check** | On a target without a prefetch instruction, the first argument's **side effects must still happen**. The original has **22 individual abort-guarded checks** of pointer/index assignments, pre/post increment/decrement, and exactly-once `getptr/getint` calls. GCC O0/O1/O2/Os **4/4 pass**; O2 main still calls and checks all 22 helpers with abort branches. KCC noopt fails to link `__builtin_prefetch`; KCC remains `no_test`. The test **does not** verify an actual cache prefetch opcode. |

Unlike the three assertion-free prefetch sources, `builtin-prefetch-4.c`
has a strong, observable argument-evaluation oracle even on the PDP-6.
No source needs to be deleted: the four retained sources either
contain recoverable hosted/compiler requirements or cannot yet
demonstrate an independently meaningful result.

## Execution accounting

- Ten original C sources x KCC noopt and GCC O0: **20 PDP-6 cells**.
- Six original, meaningful GCC tests x O1/O2/Os: **18 cells**.
- **38 bounded cells** in this batch. The 10 KCC baseline outcomes
  consist of compile/link blockers; no KCC optimized execution was
  selected.
- Of the six newly registered source owners, **24 GCC PDP-6 native
  profiles** are selected: **21 passing `semantic` and three
  `fail`**, all three optimized `built-in-setjmp.c`. No compiler
  profile is extrapolated to untested CPUs or backends.

Versioned local evidence:

- `$TMPDIR/p10tk-deferred-integration-batch14-20261118-v22`
- `$TMPDIR/p10tk-deferred-integration-batch14-gccopts-20261118-v22`

## Next review and retained requirements

The next ten-source batch (batch 15, v23) should select previously
unreviewed physical canonical identities from
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v16.tsv`, excluding all
v8-v22 ten-source review ledgers. It begins at
`tests/semantic/upstream/extensions/builtin-prefetch-5.c`.
There are **80 unreviewed** unique deferred sources and **48**
previously reviewed unique sources still deferred. The 16
consolidated open compiler gates are retained separately, not
counted as new physical source identities. Do not run broad
compiler/CPU sweeps or the 44 manual tests during this phase.
Explain any proposed deletion before removing a source.
