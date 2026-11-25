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
- [ ] Implement exact-width global C pointer representation and arithmetic.
  Baseline exact16 pointer call/roundtrip emits local/global hybrid
  literals; packed exact32 pointer initializer ICE is reproducible.
  Hardware two-word global byte-pointer literals work for direct fields,
  but escaping C pointers need a compact software ABI shared with KCC.
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
