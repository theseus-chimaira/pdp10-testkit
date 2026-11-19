# PDP10 P1 Batch 3: all ten native-width and partial-source oracles

Date: 2026-11-19. P1 concerns constructing nonvacuous test oracles.
Compiler, linker and simulator failures remain for P2. AAP architecture
correctness remains P3. All historical original-source bytes, original
source SHA256s, initial classification entries and frozen Batch 3
positions are unchanged.

## Ten original-source dispositions

| Frozen Batch 3 original | Independently verified PDP-6 oracle(s) | P1 |
| --- | --- | --- |
| `980526-2.c` | Existing ten-case `pdp10-kdev-36bit-encoding-v1.c`; new `pdp10-kdev-node-callpath-v1.c` callback for filename, mode and 36-bit device encoding | **covered** |
| `991118-1.c` | Existing six-assertion `pdp10-signed-bitfields-operations-v1.c`, by-value 52/53-bit signed XOR with both layouts | **covered** |
| `arith-rand.c` | Existing 36-case `pdp10-divmod-native-widths-v1.c`; new Python-generated `pdp10-arith-random-1000-v1.c` covering exact historical 1000-iteration LCG and six 9/18/36-bit signed/unsigned division streams | **covered** |
| `bf64-1.c` | Existing signed 52-bit OR-by-value assertions, both field/pad layouts in `pdp10-signed-bitfields-operations-v1.c` | **covered** |
| `cbrt.c` | New `pdp10-dec-cbrt-newton-v1.c`, native DEC D-format cube-root, 10 positive/negative/exact-fraction cases | **covered** |
| `921215-1.c` | Existing `pdp10-nested-trampoline-call-v1.c`: two independently counted nonvacuous nested captures; GCC O0 PASS, optimized modes retain timeout evidence | **covered** |
| `960416-1.c` | Existing full 71-bit products; new `pdp10-wide-union-overlay-v1.c` verifies physical high36:low35 layout; Python-generated `pdp10-original-wide-karatsuba-v1.c` retains the *exact original GNU union Karatsuba macro and both function bodies* with six independent native-width expected results | **covered** |
| `builtin-prefetch-1.c` | Existing address-expression side-effect assertions; new `pdp10-prefetch-original-forms-v1.c` includes all 22 unchanged original call sites and verifies no data corruption | **covered** |
| `builtin-prefetch-2.c` | Existing side effects; new `pdp10-prefetch-global-local-original-v1.c` includes all 51 original sites and executes all defined globals/statics/arguments plus a safe live-next-pointer version of original local expressions | **covered** |
| `builtin-prefetch-3.c` | Existing volatile pointer side effects; new `pdp10-prefetch-volatile-original-v1.c` includes all 46 exact volatile original sites, invokes original main and verifies state | **covered** |

No original invalid pointer conversion, undefined signed division, or
IEEE-only binary64 overlay is presented as valid PDP-10 C. Where
necessary, the companion preserves the **defined intent** with an
explicit independently justified PDP-10 model. A GCC-specific GNU
extension rejected by KCC does not become a KCC passing test.

## Newly executed native PDP-6 profiles

All eight new registered normal-matrix source files were exercised
under the actual testkit runner; **42 source/profile executions**:

| Observed outcome | Cells |
| --- | ---: |
| Real PDP-6 guest PASS | **28** |
| Genuine numbered guest assertion failure | **14** |
| **Total** | **42** |

All 12 GCC profiles for the three original prefetch families PASS.
Their corresponding side-effect companion already passed four GCC
profiles. KCC's prefetch builtin is unsupported and remains excluded
rather than linked to a test-only fake implementation.

The device callback PASSes all four GCC optimization modes, but
both KCC profiles fail `fail_id=3`, involving the original filename
pointer/character verification. The earlier native device encoder
independently passes all six KCC/GCC profiles. Pointer/addressing
repair belongs to P2.

### Reconstructed 1,000-iteration original arithmetic stress

`tools/generate-pdp10-arith-rand-v1.py` reconstructs the original
`simple_rand` LCG seed `47114711`, multiplier `1103515245`, increment
`12345`, `random_bitstring` shift/termination logic, and all **1,000**
original x/y pair generations. The only width correction is replacing
the historical hardcoded 8 bits/byte by the target's nine-bit `char`.
Six source-local test paths divide signed and unsigned native 9-bit
`char`, 18-bit `short` and 36-bit `long`. Zero divisors and signed
minimum/-1, where the original C operation is undefined or has no
representable quotient, are explicitly skipped. The source compares
four independently generated initial x/y pairs before testing any
division, so a generator mismatch cannot be misreported as a division
bug. Six rolling 36-bit signatures are recomputed with Python
arbitrary-precision integers; no 1,000-element target-side array or
large RAM budget is required.

All six profiles reach real aborts: KCC opt/noopt at signature 6
(signed 36-bit path), GCC O0/O1/O2/Os at signature 2 (unsigned nine-bit
path). **The 36-case native division oracle remains separately
registered**, and its KCC/GCC observations are preserved. These are
P2 compiler follow-ups, not a reason to delete the stress test.

### Native DEC D-format cube-root construction

Sun's historical `cbrt.c` uses IEEE double exponent constants and
exits vacuously on `__pdp10__`. This new test instead implements a
bounded 24-step Newton cube-root in actual target `double`, exercising
positive/negative 1, 8 and 27, zero, 64, and exact binary fractions
1/8 and 1/64. Independently known mathematical cube roots are checked
both directly and by cubing the result. The numerical implementation
uses genuine target floating multiplication/division, no hosted math
library, no IEEE fake constants or precomputed compiler output.
KCC optimized/unoptimized and GCC O0/O1/O2/Os all PASS.
The original IEEE-specific implementation remains a historical
source; these results verify its intended cube-root **functionality**
on PDP-10 rather than claiming the IEEE bit trick itself ran.

### Exact original 71-bit Karatsuba and union overlay

The independently specified PDP-10 unsigned 71-bit pair is two
physical 36-bit words: high 36 plus low 35 significant bits. The new
union overlay source verifies both high-first and low-first member
layouts with multiple positive values under all six KCC/GCC profiles:
**six PASS**. The second source is generated by
`tools/generate-pdp10-wide-karatsuba-v1.py`, which copies the original
source *verbatim* through its `df(f_le,t_le)`/`df(f_be,t_be)` bodies and
appends six calls with host integer-derived expected values. Python
models 36-bit unsigned subtraction/multiplication, 71-bit unsigned
products, low-word continuation and union limb ordering. No outcome
was inferred from the compilers being tested.

All six original-function profiles fail actual assertions: GCC
O0/O1/O2/Os at Karatsuba case 1 (high-first), KCC opt/noopt at case 4
(low-first). The independent full-product companion already preserves
its own original/compiler failures. No compiler, assembler, source
or runtime fix was applied to make the expected values pass.

### GNU nested trampoline and 52/53-bit operations

Both were already test-constructed. The fixed-width bitfield
operation source implements the original XOR/OR, the two struct field
orders, nonzero pads and real return-by-value semantics with six
independently computed assertions. The nested-trampoline companion
forces two real captured callbacks, eliminating the historical
`NO_TRAMPOLINES` vacuity. Successful GCC O0 execution establishes
reachability; genuine optimized SIMH timeouts are retained as future
P2 investigations. Those profiles are **not** claimed to pass.

## Evidence integrity, status and next work

`docs/PDP10-P1-BATCH3-FINAL-RESULTS-20261119-v1.tsv` stores the 42
original-owner, compiler/profile, status, failing checkpoint and
source/log SHA256 records. The actual compiler, linker, SIMH and guest
logs are archived in
`refs/pdp10-p1-batch3-final-20261119-v1.tar.gz`.

The registered host checker
`tools/verify-p1-batch3-final-v1.py` independently recomputes the
target-specific source generators and reference arithmetic, verifies
all historical original source hashes, checks normal matrix ownership,
checks each captured guest outcome without inventing a pass and fails
on missing/altered logs. Previous independently archived bitfield,
trampoline, device and 36-case divmod verifiers remain active.

Batch 3 is **10/10 P1 test-construction covered**. The global
67-original resolution becomes **38 covered, one partial, 28 blocked**;
**29 actionable P1 original obligations remain**. Of the immutable
59-source initial schedule, 30 are complete. Batch 4 contains the one
remaining partial `builtin-prefetch-6.c` plus nine blocked ABI, libc,
assembler and hosted-runtime obligations. Continue there without
reordering the original batches; compiler repairs are P2 and AAP
architecture correctness remains P3.
