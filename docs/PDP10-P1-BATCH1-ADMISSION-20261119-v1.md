# PDP10 P1 Batch 1: seven original-source admission reviews (v1)

Date: 2026-11-19. This report covers the seven previously unexamined
originals in immutable Batch 1, which already contained three completed
P1 source intents. Compiler implementation fixes and AAP correctness
expansion are outside this stage (AAP is P3).

## Eight standalone companions and their original ownership

All companions are independently registered in `COMPILER_MATRIX.tsv` and
run under the native PDP-6 profile using the normal `run-tests.sh` path.
They exercise actual original source behavior rather than accepting a
compile-only success. Original imported source bytes and SHA256 hashes
remain exactly as recorded in the historical disposition manifest.

| Original | Separate assertion-bearing companion(s) | P1 state |
| --- | --- | --- |
| `20000914-1.c` | `pdp10-enum-code-bitfield-switch-v1.c` | **partial** |
| `20010924-1.c` | `pdp10-flexible-string-initializers-v1.c`, `pdp10-fixed-string-initializer-baselines-v1.c` | **covered** |
| `20020227-1.c` | `pdp10-packed-unaligned-complex-v1.c` | **covered** |
| `20020411-1.c` | `pdp10-complex-conjugate-array-v1.c` | **covered** |
| `920302-1.c` | `pdp10-label-offset-dispatch-v1.c` | **partial** |
| `920501-2.c` | `pdp10-wide-powmod-gcd-v1.c` | **partial** |
| `920501-6.c` | `pdp10-wide-isqrt-prime-v1.c` | **partial** |

## PDP-6 compiler execution findings

The 40 original companion/compiler/profile observations comprise
**11 real PASS**, **22 real assertion failures**, **four SIMH wall
timeouts**, **two genuine KCC `__kcc_umoddi3` link failures**, and
**one KCC instruction-step exhaustion**. The latter three classes
are never rebranded as a passing or failed guest assertion.

- **Enum discriminator**: the original three enum chains and eight-bit
  field are retained exactly. Independent enumeration gives
  `AMBIG_CONV=222`. GCC O0/O1/O2/Os PASS; KCC opt/noopt fail the
  value-readback assertion. The representation of `enum code : 8` is
  implementation-defined; independently specify the supported KCC/GCC
  target policy before classifying the KCC result as a compiler defect.
- **Flexible array**: the original GNU `a3` string initializer and
  `a4` brace initializer both PASS on GCC O0/O1/O2/Os. Ordinary
  pointer/fixed-array initializer baselines are independent: KCC
  opt/noopt PASS, while GCC O0/O1/O2/Os fail the string-pointer
  baseline assertion. This separation prevents the unrelated pointer
  failure from hiding a passing flexible-array extension. KCC rejects
  the flexible-array initializer extension, so no KCC success is
  fabricated. Original source intent is covered by both tests.
- **Packed complex**: the packed structure's preceding char and both
  real/imaginary float parts are checked after a separate writer.
  GCC O0 fails the char field, while O1/O2/Os fail the complex-real
  readback. KCC does not accept the GNU complex packed declaration.
- **Complex conjugation**: GCC O0/O1/O2/Os reach a genuine failure of
  the imaginary `-1.0` result after array access, conjugation and
  float-to-double complex return. The real part is checked first.
  KCC does not support this GNU complex source form.
- **GNU label offsets**: four GCC profiles enter SIMH but time out
  with no readable `__test_exit` or `fail_id`. The label-address
  subtraction and computed goto are in the source, but guest control
  flow has not been validated; do not report a proven compiler abort.
- **Wide modulo/GCD**: independent host arithmetic confirms
  `gcd(123456,7890)=6`, `3**27%134217727=17325482`, and
  `5**7%97=40`. GCC O0/O1/O2/Os fail the power-modulo checkpoint;
  KCC opt/noopt cannot link the genuine missing `__kcc_umoddi3`
  implementation. The original Pollard factor-search loop and its
  factorization result are not executed in this bounded companion.
- **Unsigned wide integer square root and prime list**: 11 `isqrt`
  references are verified independently using host integer arithmetic,
  along with decimal parsing and a small odd-number prime interval.
  GCC **Os PASS**. GCC O0/O1/O2 fail the decimal conversion assertion;
  KCC optimized fails the first square-root result and KCC
  unoptimized exhausts its step budget at the next case. The original
  billion-scale prime interval is still a separate P1 obligation.

## Evidence and completion rules

`PDP10-P1-BATCH1-ADMISSION-RESULTS-20261119-v1.tsv` records all 40
source/profile outcomes, their explicit result categories, fail IDs
when available, original-source ownership and source SHA256. The full
original compiler, linker, simulator and guest report output is stored
in `refs/pdp10-p1-batch1-admission-20261119-v1.tar.gz` with a separate
SHA256 for every captured log. No logged observation is invented.

The registered host audit `tools/verify-p1-batch1-admission-v1.py`
reconstructs the reference enum number, integer modular arithmetic
and integer square roots, requires the original statements/operations,
checks all normal matrix registrations, verifies exact original-source
hashes and tests the actual archived outcome distinction. It can
recapture the logs with `--capture` only after a real matrix execution.

The live source resolution is version 3 and the fixed six-batch
schedule is version 2. The frozen 59 original source identities remain
exactly the same: after this review **Batch 1 has six covered and four
partial**, and globally the 67 historical sources are **14 covered,
10 partial, 43 blocked**, leaving **53 actionable P1 obligations**.
No compiler source, simulator or historical imported test was modified.
