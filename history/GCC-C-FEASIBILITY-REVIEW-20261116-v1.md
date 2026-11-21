# GCC C-test PDP-10 feasibility review (2026-11-16, v1)

**Ownership update, later on 2026-11-16:** The GCC DejaGNU driver
`gcc.target/pdp10/pdp10.exp` mentioned in the historical review below
was subsequently removed with the rest of `gcc/testsuite` by commit
`b2649d1`. The 18 applicable PDP-10 target artifacts are now preserved
in `pdp10-testkit/refs/gcc-pdp10-target-v2/`: twelve C codegen checks
have an enabled DejaGNU-free runner, three original shell assertions
have explicit registered wrappers, and one is covered by the stronger
already-registered BADL runtime/link test. See
`history/GCC-TARGET-SHELL-OWNERSHIP-20261116-v3.md`. These registrations
are not evidence of a newly completed execution sweep.

This review precedes any import of disconnected GCC C tests. Tests must
preserve their original regression assertion rather than merely compile.
Source-level classification is not compiler, assembler, or simulator
acceptance. No unreviewed upstream C test was enabled in the testkit.

## Scope and authoritative files

- `tools/audit-gcc-c-feasibility-v1.py`: read-only search-hint preflight,
  ignoring untracked and deleted source files in the working trees.
- `GCC-C-FEASIBILITY-PREFLIGHT-20261116-v1.tsv`: source hashes and initial
  risk flags for **693** original GCC C sources not byte-identical to C
  sources currently present in the testkit `tests/` tree.
- `GCC-PDP10-TARGET-FEASIBILITY-20261116-v1.tsv`: **manual** analysis of
  19 historical GCC PDP-10-specific test artifacts (15 C, four shell).
  The ITS-only CIRC source was subsequently dropped; the historical row
  is retained with a `drop-its-not-used` disposition.

The scanner reads tracked GCC sources in `gcc.c-torture/execute`,
`gcc.c-torture/compile`, `gcc.dg`, and `gcc.target/pdp10`. It excludes
byte-identical current testkit C sources, but *does not* assume that a
same-named adapted source is equivalent or that a different source with the
same assertion is absent. Counts include tests deliberately excluded from
earlier imports. The central compiler matrix is still independently
authoritative for compiler/CPU/optimization selection.

## Feasibility gate for every candidate

1. State the original *observable assertion*: runtime return/status,
   emitted code shape, diagnostic rejection, ABI contract, link behavior,
   or compile-only crash regression. A non-executed function with no
   asserted output is not a semantic test.
2. Derive expected values for PDP-10: 36-bit `int` and `long`, 18-bit
   `short`, 9-bit `char`, four addressable units per word, packing,
   alignment, sign extension, pointer arithmetic, and address-space
   restrictions. Do not substitute host 8/16/32/64-bit assumptions.
3. Floating-point expectations must follow the selected PDP-6/KA10/other
   target mode, not IEEE-754 NaNs, infinities, subnormals, rounding, or
   signed zero without independent machine-specific justification.
4. Assess required C dialect and extensions separately for KCC and GCC:
   `char6`, `__attribute__((size))`, inline assembly, 71/72-bit integers,
   varargs, special mode macros, and any unavailable standard-library or
   operating-system functions. A GCC-only test must not be silently
   presented as common KCC/GCC coverage.
5. Check the exact CPU/ISA, assembler dialect, runtime and toolchain
   configuration. ITS-only CIRC and unsupported hardware instructions do
   **not** become generic PDP-10 tests by renaming the instruction.
6. Choose one of: directly valid; adapt with invariant preserved;
   compiler/CPU-specific; defer prerequisite; duplicate with same oracle;
   or reject because adaptation destroys the assertion. Preserve original
   source and rationale for future audit.
7. When adaptation is justified, verify that the new oracle fails for the
   original defect and passes for the correction; only then register or run
   the full compiler/CPU/optimization matrix.

## Preflight queue after removal of the ITS-only source

| Original GCC group | C sources requiring review |
| --- | ---: |
| `gcc.c-torture/execute` | 76 |
| `gcc.c-torture/compile` | 11 |
| `gcc.dg` | 592 |
| `gcc.target/pdp10` | 14 |
| **Total** | **693** |

Overlapping, preliminary risk flags: 108 floating-point, 68 width/endian,
233 byte/layout, 59 hosted-library, 301 DejaGNU diagnostics, 42 assembler
assertions, 98 target restrictions, and 49 without detected flags. These
numbers are **not** verified incompatibilities: comments and nonstandard
constructs require manual interpretation, and multiple flags can apply to
the same file. Only the original 19 PDP-10-specific files have an
individual assertion-level decision in this stage.

## GCC-specific test ownership and removal of redundant central cases

GCC's original `gcc.target/pdp10/` C tests express valid target-specific
compiler constraints, chiefly packed char6 storage, 36-bit-word BSS and
BLT offsets, octal DAS operands, unsigned division branch offsets and
71/72-bit integer modes. **None of the retained 14 C sources needs IEEE
floating-point behavior.** Two scripts (`bare-dlink-libgcc.sh`,
`wide-int-mode-options.sh`) have companion C sources that should *not*
be scheduled as standalone semantic programs.

The GCC repository now has `gcc.target/pdp10/pdp10.exp`, a target-gated
DejaGNU driver for the 12 C files that contain independent `dg` compile/
assembly assertions. The two script-only companion C files are excluded
from this driver, not deleted. Their standalone script checks are retained.
This script's full DejaGNU execution is **not verified** where the
`runtest` utility is unavailable; direct GCC compilation of the 12 cases
with the declared options passed before removal of the ITS case. The
original installed GCC lacked `pdp10-its.h`; that is not a reason to
install an unused ITS feature just to satisfy an obsolete test.

Two GCC-only codegen sources were deleted from the central testkit,
along with exactly their two matrix rows:

- The deleted historical `gcc_zero_aggregate_bss_size.c` is covered by
  GCC's `bss-zero-aggregate-1.c` (the identical positive and negative
  `.space` assertions; GCC original comment corrected to 36-bit `long`).
- The deleted historical `gcc_char6_sixbit.c` combined assertions already in
  GCC `char6-cast-1.c`, `char6-sixbit-1.c`, and `char6-type-1.c`.

The GCC-owned originals compile and their key assembler patterns were
observed with installed PDP-10 GCC. The removed central entries previously
scheduled 44 GCC compiler/profile cells each, while the original DejaGNU
cases specify fixed optimization modes; that profile sweep is no longer
owned by the central matrix. This is an **intentional coverage trade-off**
for canonical GCC ownership, not evidence that all previous profile
combinations have been executed in GCC's original suite.

Do **not** delete the 1,185 other byte-identical upstream GCC sources with
active cross-compiler matrix coverage: their KCC execution and independent
PDP-10 compatibility assessment still belong to the central testkit.

### ITS-specific test disposition

`gcc.target/pdp10/its-circ-1.c` used `-mits` and emitted the ITS-only CIRC
operation. DAIMOS does not use ITS. There is no useful non-ITS adaptation
preserving its assertion. The GCC test source was deleted, not enabled in
the testkit, and an attempted change to install `pdp10-its.h` was reverted.
The optional header/backend source is otherwise unchanged. No analogous
generic PDP-10 CIRC test should be synthesized.

## Still open

- Classify the 679 non-target-specific preflight C sources one at a time,
  especially floating-point and width-sensitive cases. Reject tests whose
  useful assertion disappears when adapted.
- Determine whether any more central GCC-only test is semantically
  redundant before removing it. Preserve KCC cross-compiler assertions.
- Execute the GCC-owned DejaGNU suite with supported prerequisites and
  record actual per-test outcomes; direct compilation is not equivalent.
- Decide whether external GCC-only codegen tests require a configurable
  cross-CPU/profile sweep under GCC ownership after the source transfer.
