# Deferred integration: sixteenth ten-source batch (2026-11-18, v24)

## Scope and outcome

Review exactly ten previously unreviewed surviving canonical source
identities, beginning at `tests/semantic/upstream/extensions/complex-5.c`,
from `SEMANTIC-DEFERRED-DISPOSITION-20261118-v17.tsv`.
Exclude all prior v8-v23 ten-source review ledgers and every source
retired by the v21 SHA256 duplicate consolidation. Read original
assertions before focused PDP-6 native KCC/GCC execution. Do not
execute the broad CPU/compiler matrix or any of the 44 manually
gated tests.

**Six activated, four retained deferred, zero original C changes,
zero deleted sources.** One genuine testkit runtime-dependency
scanner bug was corrected in `tools/run-tests.py` after a source
could not link when GCC optimized a library call into a tail
`JRST`. The corrected harness loads real existing libc fragments,
not fake stubs. Every original C source is unchanged.

The 10-row `PDP10-DEFERRED-INTEGRATION-BATCH16-20261118-v24.tsv`
pins exact original/current SHA256 (identical), original disposition,
all measured baseline/optimization-specific results, the two
pre-fix link failures and post-fix results, precise native
registration statuses, and individual decisions.

Authoritative source inventories:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v19.tsv`:
  **502 active, 116 deferred, 58 removed, 1 stress-nonportable**,
  total **677** surviving canonical historical identities.
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v18.tsv`: **116**
  SHA256-pinned currently deferred identities.
- `COMPILER_MATRIX.tsv`: **2,161** registered source identities,
  six new active source owners.
- The v21 duplicate-source provenance remains **97 retired
  exact-hash aliases and zero reintroduced duplicate sources**;
  all **16 independent compiler-specific failure gates** remain
  preserved separately from canonical source identities.

## Ten original-source decisions

| Source | Decision | Actual source assertion and verified target limitation |
| --- | --- | --- |
| `complex-5.c` | **Activate GCC** | The GNU `float __complex__` function `p(a,b)` adds the two operands. Original globals `x=1+14i` and `y=7+5i` produce `z=8+19i`; `main` aborts if `z!=w`. A later assignment to `y=p(x,1/z)` is *not* independently asserted. GCC PDP-6 O0/O1/O2/Os **4/4 pass**; KCC noopt **compile fails** on GNU complex syntax. |
| `compndlit-1.c` | **Activate GCC** | GNU bitfield compound literal with designated `b:0,a:0,c:(` statement expression `)` copies previous `x` into `o`, checks previous `o.a==1` and sets `x.c=10`. Original `main` aborts unless `x.c==10`. GCC PDP-6 O0/O1/O2/Os **4/4 pass**, KCC noopt **compile fails** on the GNU dialect. This checks the resulting bitfield member, not the entire packed representation. |
| `cvt-1.c` | **Activate KCC/GCC, preserve KCC optimizer failure** | With `123456789L`, safely representable in native signed 36-bit `long`, original `f` compares converting `double` through `long` against direct `double`-to-`long` conversion, then `main` checks the returned value and comparison. GCC PDP-6 O0/O1/O2/Os **4/4 pass**. KCC noopt **passes**, KCC optimized **runtime fails**; the shared CPU-wide KCC matrix status is conservatively `fail`, while the true mode split remains in the v24 ledger. |
| `divconst-2.c` | **Activate KCC/GCC** | The fixed negative divisor `-0x7fffffffL-1L` equals `-2147483648`, which is representable without native 36-bit signed-long minimum overflow. For `-1`, `+2147483647`, and `-2147483648`, the original loop checks `quotient * divisor + remainder == numerator` or aborts. GCC O0/O1/O2/Os **4/4 pass**, KCC noopt and optimized **2/2 pass**. This is quotient/remainder recomposition, **not** hardcoded quotient values. |
| `eeprof-1.c` | **Retain deferred** | Entry/exit hooks `__cyg_profile_func_enter/exit` track exact call counts and pointers across `foo2`, `foo`, and `nfoo`, with `no_instrument_function` on selected helpers. Both GCC PDP-6 O0/O1/O2/Os and KCC noopt/optimized **runtime fail**, but the regular profiles **do not request `-finstrument-functions`**. Such failures do not independently prove incorrect instrumentation. The source needs a correctly configured instrumentation/ABI run before classification as a compiler regression. Preserve all assertions. |
| `gofast.c` | **Retain deferred** | Original hosted test checks many `float`/`double` arithmetic operations, conversions, comparisons, and `fail_count`, reporting errors through real `fprintf(stderr,...)`. GCC PDP-6 O0 **compile fails** for unavailable hosted `stdio.h`; KCC noopt **link fails** for hosted support. Do not remove the diagnostics or use fabricated `fprintf`. |
| `index-1.c` | **Retain deferred; prioritize assembler/linker issue** | Original `a[0..39]` and `f(long n)=a[n-100000]` require `f(100030L)==30` or abort. KCC PDP-6 **noopt passes**. KCC optimized and GCC O0/O1/O2/Os **all link fail** with `dlink: RH18 relocation overflow`. These are **linker failures**, not runtime assertion failures. Preserve the additional retired-alias linker-investigation evidence already recorded in the v21 consolidation. Do not patch generated relocations as a workaround. |
| `inst-check.c` | **Retain deferred** | The original defines `f(m)` as the sum of integers from 0 through `m-1`, but `main` calls **only `exit(0)`**, never `f`, and asserts nothing. KCC noopt and GCC O0 **pass vacuously**. Do not count them as proof of integer sum or varargs semantics. |
| `loop-3c.c` | **Activate GCC; preserve KCC failures** | Native `INT_MAX` loop thresholds drive repeated right shifts of `sh=0x100`, with writes through `a[sh>>=1]`; `main` checks that one entry to `f` leaves `a[0x10]` and `a[0x08]` zero, then another makes `a[0x10]` nonzero and keeps `a[0x08]` zero. GCC PDP-6 O0/O1/O2/Os **4/4 pass** with actual checked writes; KCC noopt and optimized **both runtime fail**. Retain original pointer-expression arithmetic and assertions. |
| `memcpy-1.c` | **Activate with GCC O0 failure and KCC failures** | The unchanged source uses default `MEMCPY_SIZE=1<<17` **9-bit characters per source/destination array**, checks partial/full `memcpy`, `memset` fills and a `copy` wrapper through multiple complete element-readback loops. GCC PDP-6 O0 **runtime fails**, O1 **passes**, KCC noopt and optimized **runtime fail**. Before the harness fix, GCC O2/Os compiled `copy` with `JRST memcpy`, but both **link failed** because libc selection searched only `PUSHJ` and `.extern` references. After the scanner includes **direct `JRST` references**, both O2 and Os **link and pass** with the real `kcc-libc-memcpy-v1.s` fragment. Register GCC `fail/semantic/semantic/semantic`; CPU-wide KCC `fail`. No target `memcpy` or test-source workaround was introduced. |

## Root-cause fix: freestanding library tail calls

At GCC O1, the `copy` wrapper contained `PUSHJ 17,memcpy`,
and the runner selected the real freestanding memcpy implementation.
At GCC O2/Os, the compiler correctly tail-called `memcpy` with
`JRST memcpy`, and the prior external-symbol scanner overlooked
this reference, producing an avoidable undefined `memcpy` during
linking. The runner's source-wide reference discovery now recognizes
**`JRST symbol`** in addition to **`PUSHJ 17,symbol`** and
**`.extern symbol`**. This is a general correct dependency
resolution, not an added stub or a conditional test exception.

The exact same unchanged C source was recompiled at O2 and Os
through the normal semantic runner: both now select the actual
`kcc-libc-memset-v1.s` and `kcc-libc-memcpy-v1.s` fragments,
execute the source's real loops, and pass. The original pre-fix
`link_fail` results remain in the v24 ledger as root-cause
evidence. The GCC O0 and KCC failures are still recorded.

## Bounded execution and registration accounting

The original ten sources were run under native PDP-6 KCC noopt
and GCC O0 (**20 cells**). Seven meaningful GCC sources ran at
O1/O2/Os (**21 cells**). Four KCC optimized probes examined
`cvt-1.c`, `divconst-2.c`, `index-1.c`, and `eeprof-1.c`
(**four cells**). Three additional GCC optimized `index-1.c`
link probes plus the KCC optimized `loop-3c.c` probe add
**four cells**. The repaired memcpy harness was rerun at GCC
O2/Os (**two cells**), plus an independent KCC optimized
memcpy run (**one cell**).

**52 targeted native PDP-6 executions total, without a broad
matrix sweep.** The new six matrix rows select:

- **24 GCC native PDP-6 cells**: **23 verified `semantic` and
  one `fail`** (`memcpy-1.c` O0).
- **Eight KCC native PDP-6 cells** (four KCC-capable source
  rows): **two `semantic`** for `divconst-2.c` both modes,
  and **six conservatively `fail`** for `cvt-1.c`,
  `loop-3c.c`, and `memcpy-1.c`. KCC `cvt-1.c` noopt
  really passes but optimized fails; the real split remains
  visible in the source ledger.

The codegen and relocation failures for `index-1.c` remain
unregistered and deferred for a proper linker repair. No
unsupported compiler mode, CPU, or manually gated special suite
was assumed to pass.

Versioned private execution evidence:

- `$TMPDIR/p10tk-deferred-integration-batch16-20261118-v24`
- `$TMPDIR/p10tk-deferred-integration-batch16-gccopts-20261118-v24`
- `$TMPDIR/p10tk-deferred-integration-batch16-kccopts-20261118-v24`
- `$TMPDIR/p10tk-deferred-integration-batch16-extraopts-20261118-v24`
- `$TMPDIR/p10tk-deferred-integration-batch16-memcpy-tailcall-fix-20261118-v24`
- `$TMPDIR/p10tk-deferred-integration-batch16-kcc-memcpy-20261118-v24`

## Next review cursor

The next ten-source review is **batch 17 (v25)**, beginning at
`tests/todo/generic/memcpy-2.c`. Select exactly ten unreviewed
canonical sources from the current
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v18.tsv`, excluding
all prior v8-v24 review-ledger identities. At this checkpoint,
**60 unreviewed** canonical deferred sources remain and **56
previously reviewed** sources remain deferred; **16 independent
consolidated compiler-specific gates** remain open separately.
Explain any future proposed source deletion before acting.
Continue to exclude the 44 manually gated tests and the broad
compiler/CPU sweep.
