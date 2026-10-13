# GCC torture compile test reviews

Tests are moved in groups of ten after source suitability assessment.
The matrix runs across legal profiles; the recorded instruction reviews are
representative checks, not proof for every CPU/optimization cell.
GCC sources outside this repository are not touched.


---

## Batch 1

Source: imported upstream GCC torture compile collection already in this
repository. Move accepted sources here after assessment; no GCC repository
sources or build files are changed. `TEST_MATRIX.tsv` schedules both KCC and
GCC over native, base, and legal pdp10 architecture profiles. Compiler
failures are recorded by the existing runner; no compiler fixes are made.

Representative cells examined individually: KCC PDP-6 optimized and KA10
unoptimized; GCC PDP-6 `-O0` and KI10 `-O2`. These are a sample, not an
all-cell certification. Full cross-profile plausibility reviews remain due.

| Test | Useful property | KCC sampled | GCC sampled | Assembly plausibility observations |
|---|---|---|---|---|
| 20000105-1 | unreachable exit; switch/labels and branch optimization | pass | pass | KCC retains conditional branching; GCC -O2 reduces function to exit call |
| 20000105-2 | integer/pointer cast and unused initialized variable | pass | pass | conversion/stack code at O0; GCC optimized function returns directly |
| 20000120-1 | nested conditional indexed packed-char array | pass | pass | indexed addressing, byte pointer ops, conditional branches |
| 20000120-2 | GNU extern inline and separately defined function | compile failure | pass | GCC emits odd mask and call/inlining; KCC rejects duplicate definition |
| 20000127-1 | floating arithmetic and int conversion | pass | pass | KCC PDP-6 uses FADL/conversion; KI10 GCC uses DMOVE/DFAD, consistent with target |
| 20000211-1 | complex byte-buffer side effects and expressions | compile failure | pass | GCC emits substantial MOVE/IBP/DPB and branch sequences; KCC rejects source constructs |
| 20000211-3 | label within switch default | compile failure | pass | GCC optimized empty function to POPJ; KCC parser rejects syntax |
| 20000224-1 | union/bitfield designated initializer | compile failure | pass | GCC emits DPB and conditional branch; KCC rejects initializer syntax |
| 20000314-1 | negative subscript folding in struct char array | pass | pass | byte load and bounds/index instructions; no execution attempted |
| 20000314-2 | GCC `__SIZE_TYPE__` in malloc prototype | compile failure | pass | GCC emits call or tail jump; KCC does not recognize the GCC builtin type macro |

The assembled code is **plausible, not proved correct**. These are compile-only
regressions; no runtime contract exists for most. No canonical reference ASM
exists, so instruction-sequence identity is neither required nor claimed.

The above KCC failures should be revisited as language/compiler compatibility
work separately. `semantic`/execution checks are deliberately not synthesized
from these compile-only tests.


---

## Batch 2

Both GCC and KCC were sampled on PDP-6 and respectively KI10 -O2 and KA10
unoptimized. This is a compile/codegen plausibility review, not functional
or exhaustive architecture validation.

| Test | Reason to retain | Review observations |
|---|---|---|
| 20000319-1 | trailing zero-length array parsing/layout | GCC accepts as declaration-only; empty assembly is expected; KCC rejects |
| 20000326-1 | large switch case constants | KCC emits comparison/branches; optimized GCC returns constant |
| 20000326-2 | GNU local labels and computed label address | GCC emits label address and call; KCC rejects source extension |
| 20000329-1 | endian-dependent packed-byte writes | KCC/GCC emit DPB/IDPB, masks and branches |
| 20000403-1 | old-style function definition and pointer traversal | move/branch/pointer adjustment; external sysctl need not be linked in compile-only test |
| 20000403-2 | 64-bit shift and self assignment | ASHC emitted without optimization; optimized dead expression disappears |
| 20000405-1 | floating static array indexing | loads/shifts and GCC KI10 DMOVE used |
| 20000405-2 | conditional argument conversion | conditional skip and argument move |
| 20000405-3 | aligned struct indexed pointer store | index/address computation and memory store |
| 20000412-1 | short fields exposed through char pointer | word/halfword stores and address construction |

Both sampled GCC profiles compiled all ten; KCC compiled eight and rejected
20000319-1 and 20000326-2 in both sampled profiles. Those are retained as
compile regressions, not hidden or patched. No OS/peripheral execution required.
Compilation alone is not evidence of semantic correctness. Full per-profile
one-time assembly comparison is still pending.


---

## Batch 3

All ten files retained as useful compile tests, with no required operating
system or peripheral. Representative compilation: KCC PDP-6 optimized and
KA10 unoptimized, GCC PDP-6 -O0 and KI10 -O2. All GCC cells compiled; KCC
rejected GNU label-address syntax in 20000518-1, otherwise compiled all.

| File | Useful area | Assembly observations |
|---|---|---|
| 20000412-2 | 2D character indexing/string-length call | char pointer arithmetic, IBP and loop/branch in optimized GCC |
| 20000420-1 | linked-list filtering and pointer assignment | branch/skip and memory stores |
| 20000420-2 | aggregate result and value parameter passing | PUSHJ, storage and BLT for struct copy |
| 20000427-1 | arithmetic conditions/division in loop | IDIV, branch and pointer/word moves |
| 20000502-1 | inlining/conditional minimum and globals | CAMGE/CAMLE, stores and branches |
| 20000504-1 | conditional struct field update | SKIPE/JUMPN and MOVEM |
| 20000511-1 | passing aggregate containing packed chars | LDB/DPB and calls |
| 20000517-1 | four-argument calls and local address | MOVEI and PUSHJ, stack ops |
| 20000518-1 | GNU computed-label address in inline function | GCC emits address and call; KCC rejects extension |
| 20000523-1 | pointer-size constant expressions | data-only output with expected absence of instructions |

One-time complete per-cell plausibility review remains pending; source
compiler defects were neither masked nor modified. The matrix enables all
legal profiles, not only representative ones.


---

## Batch 4

All ten files retained for compiler/ABI coverage. Checked KCC PDP-6 opt
and KA10 noopt, GCC PDP-6 -O0 and KI10 -O2. GCC compiled all ten; KCC
rejected 20000701-1 (void lvalue expressions), all other tests compiled.

| Test | Purpose and observed assembly |
|---|---|
| 20000605-1 | void expression/return types; calls/branches and optimized jump |
| 20000606-1 | incomplete struct extern and member store; SETZM/POPJ |
| 20000609-1 | stack char buffer initializer/reading; BLT, LDB, IBP |
| 20000629-1 | bounded loops over pointer-linked structs; stores, counters, branches |
| 20000701-1 | volatile and const void expression handling; KCC rejects, GCC drops side-effect-free expressions |
| 20000717-1 | short-pointer dot product; byte/halfword loads, shifts, loops |
| 20000718 | floating conversion and calls in a loop; MOVE/PUSHJ/conditional jumps |
| 20000728-1 | endless loop and uninitialized scalar; GCC optimizes to JRST |
| 20000802-1 | packed character pointer subtraction and memcpy; DPB, IBP, byte arithmetic |
| 20000803-1 | backwards char-buffer copy; indexing, LDB/IBP, loop control |

No tests were executed; tests requiring external runtime calls are compile
checks only. Correctness and per-cell plausibility remain to be established
beyond representative reviewed instruction sequences.

---

## Batch 5

Representative profiles: KCC PDP-6 opt/KA10 noopt; GCC PDP-6 -O0/KI10
-O2. All ten GCC compilations passed. KCC rejects six GNU-language-specific
sources (20000804-1, 20000827-1, 20000923-1, 20001024-1, 20001109-1,
20001109-2) and compiles four.

| Test | Compiler coverage and generated-assembly inspection |
|---|---|
| 20000804-1 | GNU complex integer and inline assembler operands; GCC emits DMOVE/DMOVEM and arithmetic, KCC rejects |
| 20000818-1 | aggregate containing long double; KCC/GCC stack and data moves, optimized away when unused |
| 20000825-1 | unsigned shift/mask and inline semantics; move, calls, literal-mask formation |
| 20000827-1 | optimization common-subexpression constraints; GCC JFCL/ANDI and conditional branch; KCC rejects |
| 20000922-1 | constant detection and inline asm operand constraints; GCC generates call or optimized jump |
| 20000923-1 | variable array and inline asm operand; GCC stack allocation with MUL/shift, KCC rejects |
| 20001018-1 | incomplete/complete extern array sizes and sizeof; only codegen for empty function |
| 20001024-1 | GCC size-type macro and memset expression; GCC conditional and stores, KCC rejects |
| 20001109-1 | alignment of late-defined incomplete struct type; data-only/no instructions; KCC rejects GNU alignof |
| 20001109-2 | second incomplete-struct alignment form; data-only/no instructions; KCC rejects GNU alignof |

No source requires a foreign operating system or hardware-specific processor.
GNU C extensions intentionally remain compiler compatibility coverage. One-
time exhaustive per-cell assembly audit remains pending.

---

## Batch 6

Source inspection and KCC PDP-6 optimized/KA10 unoptimized plus GCC PDP-6
-O0/KI10 -O2 compilation. GCC compiled 10/10. KCC compiled four and rejected
six (20001116-1, 20001123-1, 20001205-1, 20001221-1, 20001222-1,
20010102-1). All are generic source-level compiler stress tests: mentions
of PowerPC, SH and SPARC concern original bug history, not required hardware.

| Test | Purpose and assembly review |
|---|---|
| 20001116-1 | constant pointer-expression initializer; data output only, KCC rejects |
| 20001121-1 | GNU statement expression and switch case lowering; branches and calls |
| 20001123-1 | builtin variadic argument extraction; GCC conditional/moves, KCC rejects builtins |
| 20001123-2 | control-flow labels and branch optimization; comparisons, jumps and calls |
| 20001205-1 | inline assembly/register output constraints; GCC optimized bitwise AND/LSH/IOR, KCC rejects |
| 20001212-1 | long-double aggregate parameter and arithmetic; moves/calls, optimized empty result |
| 20001221-1 | complex variable-length char buffers; GCC expands to many moves, jumps, MUL and byte ops; KCC rejects |
| 20001222-1 | complex floating complement; GCC uses DMOVE on KI10, KCC rejects |
| 20001226-1 | extremely large branch-shortening stress case; 33k/40k PDP-6 assembly lines and 19k optimized KI10; comparisons and branches dominate |
| 20010102-1 | obstack-style pointer arithmetic and loop optimization; GCC shifts/stores/branches, KCC rejects |

No source or compiler errors corrected. Compiler output checked for plausible
instruction families; full per-cell review remains outstanding.

---

## Batch 7

Ten generic C compiler tests, no required OS/hardware. Representative
checks: KCC PDP-6 opt, KA10 noopt; GCC PDP-6 -O0, KI10 -O2. GCC compiled
all ten; KCC rejected 20010114-2 and 20010124-1 and compiled eight.

| Source | Purpose and plausible output |
|---|---|
| 20010107-1 | function pointer derived from address; PUSHJ through pointer |
| 20010112-1 | optional fixed-register variable with generic fallback; trivial return |
| 20010113-1 | static pointer initializer constant; data only |
| 20010114-1 | typedef shadowing by parameter; simple function return |
| 20010114-2 | C99 bool/aggregate initialization; data only, KCC rejects |
| 20010117-1 | unsigned byte subtraction and sign bit check; LDB/TRNE/DPB |
| 20010117-2 | unsigned narrow arithmetic, masks, stores; LDB, ANDI, SUB and DPB |
| 20010118-1 | static counter, loop, call and pointer side effects; PUSHJ/AOS and branches |
| 20010124-1 | frontend initializer/declaration regression; data only, KCC rejects |
| 20010202-1 | VLA parameter declarator and empty body; stack setup absent when optimized |

Architecture-specific register names, where present in conditional source,
are disabled by preprocessor on PDP-10. Compile-only, no semantic pass claim.

---

## Batch 8

Sampled KCC PDP-6 opt/KA10 noopt and GCC PDP-6 -O0/KI10 -O2. GCC
compiled all ten. KCC compiled five; it rejected 20010226-1,
20010313-1, 20010327-1, 20010328-1 and 20010404-1.

| Test | Source purpose and observed code |
|---|---|
| 20010209-1 | floating literal to short integer constant; HRRM store |
| 20010226-1 | nested GNU function/captured variable and callback; GCC branches/calls, KCC rejects |
| 20010227-1 | double local variable address/liveness; loads/stores removed under optimization |
| 20010313-1 | parser-only attribute declarator; correctly emits no code, KCC rejects |
| 20010320-1 | nested struct/bitfield control flow; move/conditional branches, optimized dead code disappears |
| 20010326-1 | floating aggregate conditional assignment; move/comparison, optimized dead code disappears |
| 20010327-1 | external-symbol address constant relocation; GCC PDP-6 emits `.long _txt+68602036223`, appropriate signed offset modulo 36-bit word; assembler acceptance not yet confirmed |
| 20010328-1 | wide integers and compatibility typedefs; GCC LSH, DMOVEM, stores, KCC rejects |
| 20010329-1 | conditional union field set; DPB and branch |
| 20010404-1 | division/modulo constant optimizer regression; GCC IDIV or optimized call/jump, KCC rejects |

All tests target generic source-language constructs. No CPU-specific runtime,
filesystem or external OS execution is needed. No compiler fixes attempted.

---

## Batch 9

Nine accepted generic compiler tests, one removed as unusable on PDP-10.
KCC PDP-6 opt/KA10 noopt and GCC PDP-6 -O0/KI10 -O2 were compiled.
GCC compiled all candidates; KCC rejected 20010423-1, 20010510-1,
20010516-1 and 20010518-2.

| Test | Purpose and representative assembly |
|---|---|
| 20010408-1 | linked structures and command dispatch; MOVE/JRST/PUSHJ/LDB |
| 20010421-1 | long-double variable and bounded loop; counter and jumps |
| 20010423-1 | boolean conversion regression; LDB/ANDI/store, KCC rejects |
| 20010426-1 | loop with noreturn call and struct fields; stores, branches |
| 20010503-1 | double argument and dispatch between functions; calls/DMOVE |
| 20010510-1 | `#ident` parser extension; expected absence of instruction output, KCC rejects |
| 20010516-1 | GNU assembly memory-constraint handling; address computation and stores, KCC rejects |
| 20010518-1 | complex GCC reload/flow stress from historical PowerPC bug; generic C operations, LSH/IOR/LDB/IBP |
| 20010525-1 | memcmp result, return path and branch; PUSHJ/JUMPN |

**Excluded/deleted:** 20010518-2.c (`volatile char chars_1[INT_MAX/2]`)
requires an unrealizable PDP-10 static object far beyond addressable memory.
It is not entered in the matrix or kept in the unreviewed source directory.
