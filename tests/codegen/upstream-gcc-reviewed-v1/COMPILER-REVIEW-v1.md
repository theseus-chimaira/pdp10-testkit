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

---

## Batch 10

Ten source-level GCC torture compile tests. Representative KCC PDP-6 opt/
KA10 noopt and GCC PDP-6 -O0/KI10 -O2: GCC compiled all ten, KCC failed
20010605-1 and 20010610-1 (GNU VLA/nested function and bool declarations).

| Test | Purpose and assembly plausibility |
|---|---|
| 20010605-1 | VLA-based aggregate and nested function; GCC computes variable frame addresses and calls |
| 20010605-2 | struct-to-same-type cast through typedef; value moves |
| 20010605-3 | simple pointer check with disabled IA64-only conditional; MOVE/JUMPE and constant result |
| 20010610-1 | bool as array size/switch selector; GCC calls/returns; KCC rejects |
| 20010611-1 | qualified function arguments and type compatibility; constant return |
| 20010701-1 | postfix attribute declaration parser; no emitted instructions expected |
| 20010706-1 | unsigned shift/rotate idiom; LSH/IOR |
| 20010711-1 | 64-bit decrement and compare with call; DMOVE and SUBI |
| 20010711-2 | 64-bit decrement/equality variation; DMOVE, branch/call |
| 20010714-1 | attribute placement on declarations; no emitted instructions expected |

No unsupported OS or special processor is required. The guarded IA64-only
assembly in 20010605-3 is inactive on the PDP-10. Per-cell review beyond
these representative profile comparisons remains outstanding.

---

## Batch 11

All ten generic compiler stress sources retained. GCC PDP-6 -O0/KI10 -O2
compiled 10/10; KCC PDP-6 opt/KA10 noopt compiled seven, rejecting
20010903-1, 20010903-2 and 20011023-1 (GNU inline asm/nested function).

| Source | Review observations |
|---|---|
| 20010824-1 | recursive control flow and label; JUMPE/SUBI/PUSHJ or optimized SOJA |
| 20010903-1 | GNU inline assembler tied memory operand and clobbers; GCC address/loop code |
| 20010903-2 | local nested inline function; GCC call/prologue, KCC parser rejects |
| 20010911-1 | empty attribute list parser check; no instructions |
| 20011010-1 | GNU statement expression in loop increment; calls, tests and jumps |
| 20011023-1 | nested prototyped function and closure; GCC address building and calls |
| 20011029-1 | builtin setjmp/noreturn handling; conditional and frame saves, compile-only |
| 20011106-1 | function-pointer comma operator type; data definitions only |
| 20011106-2 | conditional aggregate-field types; data definitions only |
| 20011109-1 | packed short arrays, function pointers and aggregate operations; DPB/IBP/LSH and DMOVE |

No foreign OS/hardware required to compile. No code correctness beyond
representative plausibility claimed.

---

## Batch 12

Ten generic compile tests accepted. GCC PDP-6 -O0/KI10 -O2 passed
all ten; KCC PDP-6 opt/KA10 noopt compiled six, rejecting 20011114-1,
20011119-1, 20011119-2 and 20011205-1. No changes to compiler code.

| Source | Source-level value and plausible assembly |
|---|---|
| 20011114-1 | GCC `__SIZE_TYPE__` external address initializer; data-only relocation, KCC rejects |
| 20011114-2 | packed bitwise flags/combinations; IORB/LSH/IORM |
| 20011114-3 | state machine with switch and calls; conditional jumps and PUSHJ |
| 20011114-4 | variable-length base-128 signed integer encoder; ANDI/branch/shift |
| 20011119-1 | weak alias + GNU extern inline; code and alias metadata, KCC rejects |
| 20011119-2 | weak alias/inline interaction; calls, JRST and constant returns; KCC rejects |
| 20011130-1 | incomplete aggregate pointer declaration; direct external call |
| 20011130-2 | generic branch/if-conversion stress originally found on IA64; IBP and extensive conditional flow |
| 20011205-1 | inline-asm operand liveness constraint; address/stores, KCC rejects |
| 20011217-1 | compound literal in inline expression; value moves, optimized return |

No target-dependent assembly executed; compilations and representative
instruction inspection only. Additional per-cell review remains necessary.

---

## Batch 13

Ten useful generic compiler tests retained, including historical Alpha,
IA64, MMIX and PowerPC regressions whose C source does not need those CPUs.
Representative KCC PDP-6 opt/KA10 noopt: nine pass, 20011217-2 fails.
GCC PDP-6 -O0: nine pass, 20011217-2 fails; GCC KI10 -O2: ten pass.

| Test | Plausibility inspection |
|---|---|
| 20011217-2 | compound-literal inline/finite handling; fails KCC and GCC PDP-6 -O0, GCC optimized KI10 uses DMOVE/IOR |
| 20011218-1 | multiplication/division with indirect calls; IDIV, masks, shifts |
| 20011219-1 | allocation/index arithmetic for multidimensional double pointers; DMOVEM and address math |
| 20011219-2 | conditional float/aggregate handling; TLC, DMOVE/DMOVEM, conditional branches |
| 20011229-1 | function pointers/aggregate color dispatch; PUSHJ, LDB, branch |
| 20011229-2 | jump threading to exit; SOJN/SOJE and call/jumps |
| 20020103-1 | conditional/quotient branch optimization; IDIV/DMOVEM |
| 20020106-1 | wide signed comparison/postincrement; DMOVE and conditional jump |
| 20020109-1 | multiple branch successors; SKIPN/JUMPE/CAME |
| 20020109-2 | union byte/short manipulation; LDB/DPB and data address ops |

Compiler failures are evidence, not grounds for patching. Exact code
correctness and complete architecture/optimization review remain open.

### Batch 1 complete legal-profile comparison

The first ten sources were subsequently compiled in **all 66 legal profiles**:
22 KCC (native/base/pdp10, optimized and unoptimized) and 44 GCC (native,
base, pdp10; -O0/-O1/-O2/-Os). **440/440 GCC cells passed compilation**.
For KCC, five sources passed every profile (**110 cells**) and five sources
failed every profile (**110 cells**); no anomalous CPU-specific status changes.

Instruction/assembly-size comparisons across all successful cells found
plausible systematic differences:

- Unoptimized GCC retains stack and local-variable setup; optimized code
  frequently reduces to a return, jump or constant result.
- On PDP-6, packed-char test 20000120-1 uses IBP/LDB/DPB; native KS10
  optimized code uses ADJBP for pointer arithmetic and fewer instructions.
- Floating test 20000127-1 uses FADL/soft conversion paths in the PDP-6
  assembly while KS10 native optimized code uses DMOVE, DMOVEM and DFAD.
- KCC's optimized and unoptimized output follows consistent variations in
  stack setup and conditional branches across the supported CPU families.

The all-cell inventory was inspected for status and opcode/size outliers.
No additional ISA-policy failures were reported. Original per-cell artifacts
are transient in `$TMPDIR/pdp10-torture-allcells-b01-v1`, **not** repository
results or historical fixtures. This is source-level assembly plausibility
review, not assembler acceptance or proof of semantic equivalence.

---

## Batch 14

Ten useful generic compiler regressions. Representative KCC PDP-6 opt/
KA10 noopt compiled seven; KCC rejected 20020210-1, 20020303-1 and
20020309-1. GCC PDP-6 -O0 and KI10 -O2 compiled all ten.

| Test | Source purpose and plausible emitted code |
|---|---|
| 20020110 | nested extern/static declaration scope; simple return |
| 20020116-1 | loop/callback/noreturn control flow; branches and calls |
| 20020120-1 | complex aggregate byte/field conversions; LDB/DPB/LSH and FIX |
| 20020121-1 | bit-field masking and truncation; DPB/ANDI/SETZM |
| 20020206-1 | conditional byte stores from optimizer ICE; DPB/IBP and branches |
| 20020210-1 | VLA member in function parameter; stack parameter support; KCC rejects |
| 20020303-1 | weak symbol in BSS; data-only metadata, KCC rejects |
| 20020304-1 | large multi-function branch/reorder case; MOVE/PUSHJ/JRST, 200+ optimized assembly lines |
| 20020304-2 | volatile 72-bit read/compare; IOR/DPB and conditional branch |
| 20020309-1 | nested GNU function and captured pointer; GCC address/IBP operations; KCC rejects |

No source requires a foreign runtime or unavailable CPU to compile. Further
full per-cell opcode/size review outstanding for batch 14.

---

## Batch 15

Ten generic C source-level compiler regressions accepted. Sampled KCC
PDP-6 opt/KA10 noopt: eight compile, 20020312-1 and 20020409-1 reject.
GCC PDP-6 -O0/KI10 -O2: all compile.

| Test | Plausibility of code-generation features |
|---|---|
| 20020309-2 | floating/integer union modes; moves and DMOVE |
| 20020312-1 | inline bit/flag optimizer expression; LSH and MOVSI, KCC rejects |
| 20020314-1 | function calls and pointer-bearing request structs; PUSHJ and conditional branch |
| 20020315-1 | two call comparisons and signed results; PUSHJ, TDZA/SKIPG |
| 20020318-1 | old-style char argument, inlining; DPB, stack and call |
| 20020319-1 | array address constant and signed index; ASH, DPB and branches |
| 20020320-1 | function-pointer table, control-flow jump; LDB/JUMPN |
| 20020323-1 | pointer/char indexing from generic RTL regression; CAMGE/CAML and stores |
| 20020330-1 | multi-dimension arithmetic, call and aggregate pointers; address and call |
| 20020409-1 | INT_MAX overflow constant simplification; optimized ADD/POPJ, KCC rejects |

Historical x86/IA64/PowerPC bug origins do not make the C tests specific to
those processors. No runtime or external OS dependency exercised. Full
cross-cell review remains separate.

---

## Batch 16

Ten useful processor-independent compile tests from upstream torture set.
KCC PDP-6 opt/KA10 noopt compiled all ten; GCC PDP-6 -O0 failed on
20020617-3, while GCC KI10 -O2 compiled all ten. No errors repaired.

| Test | Plausible emitted code |
|---|---|
| 20020617-1 | struct-sized memcpy; BLT or call depending compiler/optimization |
| 20020617-2 | packed 32-bit array and 8-bit byte copying; ANDI/LSH/ASH and pointer moves |
| 20020617-3 | builtin memset of struct; GCC -O0 fails, optimized KI10 emits SETZM/BLT |
| 900116-1 | loop copying packed struct members; LDB and MOVEM |
| 900216-1 | unsigned short dereference and constant comparison; LDB/LSH/IOR and CAIE |
| 900313-1 | alloca and many-argument call stress, stack/address adjustments, 400+ lines per compiler |
| 900407-1 | 36-bit constant truncation/compare; ADDI/CAMN/JRST |
| 900516-1 | floating conditional simplification; conditional skip/constant return |
| 920301-1 | GNU computed label values and static arrays; no runtime, trivial function returns |
| 920409-1 | discarded float/conditional expression; optimized empty return |

The large alloca values in 900313-1 form a compiler stress case but are
not intended to be executed on a constrained PDP-6. No OS/hardware dependency
is required for compilation. Full per-cell review remains pending.
