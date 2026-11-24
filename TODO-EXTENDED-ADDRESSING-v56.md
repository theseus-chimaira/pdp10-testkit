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
- [ ] Integrate optional KLH10 execution into the common C matrix after
  the host-only extended image transport is available (EA03/EA04).

## EA02: Define and implement assembler/object relocation contract

- [x] Audit selector and indirect-word encodings against KL10B execution.
  Installed DAS baseline: 21 selectors incorrectly emitted as local P/S
  pointers, five before-first selectors rejected (0/26 correct). See
  `manifests/PDP10-DAS-OWGBP-BASELINE-20261124-v56c.tsv`.
- [ ] Correct DAS OWGBP encoding and local-address test oracles that
  incorrectly expect a local P/S pointer for OWGBP.
- [ ] Preserve 30 address bits and six selector/control bits; support
  absolute and symbolic expressions, signed addends and overflow checks.
- [ ] Define versioned object relocation records for global addresses,
  including local versus external symbols. Reject unsupported combinations.
- [ ] Keep existing DOBJ1 files and RH18/LH18 output byte-compatible;
  do not add resident native assembler state for host-only relocations.
- [ ] Audit archive, objdump, folding and relocation consumers; fail closed
  on unsupported extended objects rather than truncate addresses.

## EA03: Host-only link and execution transport

- [ ] Support explicit section placement for code, data and stack, and
  cross-section symbol resolution. No change to DAIMOS DXR formats.
- [ ] Add a separate host-only execution transport for extended programs,
  preserving physical/virtual address distinction and sparse placement.
- [ ] Add nonzero-section startup, exact HALT/sentinel validation and
  negative controls to the test harness. Preserve local profile behavior.
- [ ] Exercise relocation at nonzero sections and section boundaries,
  including function pointers, static initializers and external symbols.

## EA04: GCC C compiler and runtime

- [ ] Establish four optimization profiles (O0/O1/O2/Os) with staged GCC.
- [ ] Audit supported code models; reject unsupported combinations.
- [ ] Fix extended record-array ICE in expr.c and all demonstrated
  incorrect pointer arithmetic, conversions and address materialization.
- [ ] Verify native byte/halfword/word pointers and explicit-width packed
  data, signed differences, side effects, static and indirect addressing.
- [ ] Validate global stack, direct/indirect calls, aggregate ABI, varargs,
  function pointers and cross-section control flow.
- [ ] Build and validate extended libgcc and freestanding C runtime;
  audit global byte subtraction tables and memory/string operations.
- [ ] Verify multi-section tests before admitting existing C sources to a
  separate extended-address failure matrix. No C++ acceptance requirement.

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
