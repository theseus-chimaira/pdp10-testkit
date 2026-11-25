# Extended addressing: GCC and KCC (v56)

Scope: freestanding KL10B C toolchains, with the minimum shared assembler,
linker, image transport and simulator prerequisites. No DAIMOS changes.
Do not alter the DAIMOS loader, executable format, kernel, or syscall ABI.
Preserve local-address ABI, native RAM and performance. C++ is out of scope.
The existing 2124 historical local-address runtime failures are a separate
backlog, not an extended-address failure count.

## EA01: Establish independent KL10B execution

- [x] Verify the installed simulator exposes KL10B.
- [x] Establish guest-controlled TOPS-20 paging and execute in section 1.
- [x] Demonstrate global indirect read, OWGBP LDB/DPB, section 2 call
  and return with a section 3 stack, without a DAIMOS dependency.
- [x] Register reproducible positive and negative controls; record evidence.
- [x] Extend to all architectural OWGBP selectors, IBP/ADJBP, boundary
  crossings, XMOVEI and XBLT, with independently specified encodings.

EA01 complete in v56b/v56c: both startup controls and all 92 instruction
assertions plus 20 physical memory observations pass on the installed
KL10B simulator. This is an ISA reference, not compiler acceptance.

Independent second emulator (v56e):

- [x] Build and install KLH10 KL10B and KS10 under PDP10_PREFIX.
- [x] Replay local execution on both models, cross-section positive and
  negative controls on KL10B, and all 92 global ISA assertions on KLH10.
- [x] Use KLH10 only in dedicated extended-address regression tests.
  Do not add CPU profiles or emulator backends to COMPILER_MATRIX.tsv.

## EA02: Define and implement assembler/object relocation contract

- [x] Audit selector and indirect-word encodings against KL10B execution.
  Installed DAS baseline: 21 selectors incorrectly emitted as local P/S
  pointers, five before-first selectors rejected (0/26 correct). See
  `manifests/PDP10-DAS-OWGBP-BASELINE-20261124-v56c.tsv`.
- [x] Correct DAS OWGBP encoding and local-address test oracles that
  incorrectly expect a local P/S pointer for OWGBP.
- [x] Preserve 30 address bits and six selector/control bits; support
  absolute and symbolic expressions, signed addends and overflow checks.
- [x] Define versioned object relocation records for global addresses,
  including local versus external symbols. Reject unsupported combinations.
- [x] Keep existing DOBJ1 files and RH18/LH18 output byte-compatible;
  do not add resident native assembler state for host-only relocations.
- [x] Audit archive, objdump, folding and relocation consumers; fail closed
  on unsupported extended objects rather than truncate addresses.

EA02 v56h: DOBJ2 uses typed local/symbol ADDR30 records with signed
36-bit addends of at most 30-bit magnitude. The legacy DXR linker,
p10fold and p10super explicitly reject DOBJ2; darc preserves its
members and objdump displays the new records. The independent oracle
passes all 26 selectors, mixed relocations and malformed-input guards.
The installed production tools remain unchanged until acceptance.

## EA03: Host-only link and execution transport

- [x] Initial host-only explicit TEXT, DATA and BSS placement and
  cross-section symbol resolution, with an independently mapped stack.
  No changes to DAIMOS DXR formats.
- [ ] Support multiple TEXT placement ranges and cross-section C calls.
- [x] Add a separate host-only execution transport for extended programs,
  preserving physical/virtual address distinction and sparse placement.
- [x] Add nonzero-section startup, exact HALT/sentinel validation and
  negative controls to the test harness. Preserve local profile behavior.
- [ ] Exercise relocation at nonzero sections and section boundaries,
  including function pointers, static initializers and external symbols.

## EA04: GCC C compiler and runtime

- [x] Correct global static pointer initializers, constant selector
  conversions, signed ADJBP folding and nested initializer casts (v56i).
  Verify object contents in all four optimization modes. These are
  object-generation checks, not extended runtime passes.
- [x] Execute dedicated native pointer C regression at O0/O1/O2/Os
  with independently mapped code, data, BSS and global stack on SIMH
  and KLH10 (v56m/v56n/v56o).
- [x] Correct DAS XMOVEI opcode 0415 and GCC native extended halfword
  loads/stores. Local packed bit-pointer representation remains unchanged;
  global exact-width packed pointers need further work.
- [ ] Audit supported code models; reject unsupported combinations.
- [x] Fix extended native record-array ICE in expr.c, dynamic member
  address construction and invalid aligned-global-byte-load shortcut.
  Native 9/18-bit pointer differences use 30-bit address coordinates
  and selector differences rather than runtime tables (v56q). Both
  dedicated record and existing switch regressions pass all four
  optimization modes on SIMH and KLH10.
- [x] Verify native 6/7/8-bit array loads/stores, signed differences,
  adjustment, static offsets, aligned word-pointer and null conversions
  (v56s). Replace correction tables with bounded shifts/additions; save
  77-83 linked words in the regression.
- [x] Verify 36-bit unsigned multiplication and normalized 71-bit wide
  multiplication. Fix common 71-to-36 truncation, including register and
  memory paths; preserve raw72. Dedicated extended and local tests pass
  (v56x); no changes to historical matrix statuses.
- [x] Verify direct, constant-index exact16/32 packed field loads/stores
  and neighboring bitfield preservation in extended mode (v56t/v56x).
- [x] Host-only tagged ADDR30 emission via `%GADDR(tag,address)` and
  independent one-word exact16/32 pointer-model execution (v56y).
  All 36 packed bit positions and native exact-width slots validated;
  3398 arithmetic rows and 75 field read/write rows per execution.
  This validates the candidate representation, not compiler lowering.
- [x] GCC exact32 global typed pointers (v57d): native word slots,
  packed tags 1..36, static and dynamic member addresses, automatic
  word-addressed records, typed accesses, signed arithmetic and both
  branch/boolean relational ordering. New and historical fixtures pass
  all four optimization profiles on SIMH and KLH10.
- [x] GCC exact16 global typed pointers (v57i): native two-per-word
  slots 045/054 octal, packed bit-position tags, standalone scalars,
  signed access, static positive/negative offsets, dynamic arithmetic,
  subtraction and ordering. Five dedicated cases pass O0/O1/O2/Os on
  SIMH and KLH10. Mixed compiler ABI remains open.
- [x] GCC extended void-pointer round trips and tested mixed-width casts
  (v57n): preserve exact-width and explicit subbyte tags, retain canonical
  standard C void/character pointers, shared packed conversion tables,
  nulls, symbolic initializers, comparison and side effects. Fix direct
  dynamic packed exact32 reads/stores. Two fixtures, 16 executions pass.
- [x] Verify compiler-generated dynamic exact-width pointer arithmetic
  across the 30-bit address-coordinate range (v57o): 4286 host-oracled
  rows, seven checks per row, all four optimization profiles on SIMH
  and KLH10. High virtual addresses are arithmetic-only ABI probes.
- [x] Verify typed exact16/32 physical accesses across page and section
  boundaries (v57o): 450 signed/unsigned field rows and 58 non-crossing
  cases with the next section unmapped, eight executions. Host-only
  explicit sparse test mappings; no P10X format or linker change.
- [x] Verify absolute constant-folded scalar exact16/32 pointer addition
  and subtraction of element counts (v57q): 8572 static words per
  optimization profile, 34288 total, independent full-range oracle.
  Fix premature generic C-unit folding and share the host coordinate
  calculation. This is an object-generation check, not runtime execution.
- [x] Verify absolute constant-folded exact16/32 same-array differences
  and comparisons (v57r): 8572 differences and 25716 comparisons per
  profile, 137152 total; repair rejected differences and wrong ordering.
- [x] Verify native 6/7/8/9/18/36-bit dynamic arithmetic and physical
  boundary operations (v57s): 1835 arithmetic and 88 memory rows per
  execution, eight executions. Repair extended switch vectors and
  native pointer ordering, retaining local code generation.
- [x] Verify absolute scalar native constant-folded pointer adjustment,
  differences and relations (v57t): 73400 object-word checks over six
  canonical native widths and four optimization profiles. Share the
  exact-width scalar front-end hooks; no target runtime overhead.
- [x] Native scalar symbolic ADDR30 adjustment within signed 30-bit
  RTL addend range (v57u): 4944 relocations and linked words across
  eight widths and four optimization profiles. Fix host int truncation
  of native ADJBP counts.
- [x] Verify packed exact16/32 signed symbolic endpoints and chained
  adjustments (v57v): 17280 object relocations and 17280 linked words.
  Diagnose overflowing exact-width constant symbolic adjustments before
  masking; 16 rejection controls reproduce opposite-sign baseline adds.
- [x] Independent symbol/selector/displacement RTL for wide packed
  exact16/32 symbolic adjustments (v57x): 14472 relocations and linked
  words, 64 distinct code literal checks, 16 extreme displacement
  object checks, 16 impossible-addend rejection controls, eight runtime
  profiles. Replace v57v signed-range rejection with correct relocation.
- [x] Wide native scalar adjustment and word-address constant arithmetic
  (v57zb): 9888 relocations and linked words, 192 distinct required
  wide code relocations, eight positive function-return executions.
  Fix chained native initializers and negative native literal output.
- [x] Wide symbolic casts through void, exact16/32, and aligned native
  conversions (v58a): 24848 object relocations and linked words, 728
  distinct required code relocations, eight runtime profiles. Preserve
  independent displacement and existing selector conversion policies.
- [x] Native scalar displacement limits (v58a): 64 exact extreme
  objects and 64 impossible displacement rejection controls.
- [ ] Validate wide direct aggregate construction, indirect address
  consumers and remaining combined expressions. Arbitrary misaligned
  native-to-native conversion semantics remain open.
- [ ] Retain v57zb ADJBP diagnostic discrepancy: for six-bit pointer
  0460002001000 and count 027777777777, SIMH returns 0530002000777
  instead of 0534002000777; KLH10 passes the same diagnostic image.
  Existing dynamic boundary tests pass. No emulator changes in scope.
- [ ] Remaining cast semantics and aggregate layouts.
- [ ] Minimize exact-width inline arithmetic/access code, including
  shared quotient/remainder computation and constant-position access.
- [ ] Verify additional aggregate layouts, arbitrary packed pointer casts
  and dynamic packed member indices.
- [ ] Verify native byte/halfword/word pointers and explicit-width packed
  data, signed differences, side effects, static and indirect addressing.
- [ ] Validate global stack, direct/indirect calls, aggregate ABI, varargs,
  function pointers and cross-section control flow.
- [ ] Build and validate extended libgcc and freestanding C runtime;
  audit global byte subtraction tables and memory/string operations.
- [ ] Verify multi-section tests in dedicated regressions outside the
  existing compiler matrix. No additional CPU/emulator profiles or C++
  acceptance requirement.

## EA05: KCC C compiler and common ABI

- [ ] Audit dormant MULTI_SECTION implementation and historical runtime
  dependencies. Keep klx rejected until it is genuinely functional.
- [ ] Enable an explicitly selected KL10B compiler build; repair codegen,
  addressing, runtime helpers and startup, using the common host tools.
- [ ] Validate KCC optimization profiles and same pointer/aggregate/call
  semantics as GCC; compare cross-compiler objects and mixed calls.
- [ ] Retain section-0 kl10 behavior and all older CPU configurations.

## EA06: Acceptance and integration

- [ ] Run dedicated extended positive/negative tests and applicable C
  regression cohorts; count only observed runtime outcomes.
- [ ] Replay local-address compiler, assembler, linker and runner guards.
- [ ] Measure native RAM, object word counts and comparable runtime speed;
  reject unintended local-address costs.
- [ ] Document verified ABI and target limitations in pdp10-doc only
  after each completed stage; commit and push each verified repair.
- [ ] Install only accepted toolchain artifacts through local.tar.gz under
  PDP10_PREFIX. DAIMOS implementation remains out of scope.
