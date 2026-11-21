# PDP-10 complete compiler-test integration and ICE-focused harness (v1)

Date: 2026-11-21. This is a **test registration and runner acceptance**
checkpoint. It does not state that every guest has executed or that a
failed compiler/runtime assertion has passed. Non-ICE defects are now
intentionally report-only during an explicitly selected ICE sweep.

## Inventory and separate success definitions

| Inventory/gate | Verified status |
| --- | ---: |
| Compiler matrix source rows | 2,358 |
| Enabled special suite registrations | 390 |
| Manual special suite registrations | 22 |
| Owned standalone/delegated script paths | 585 |
| Source-registered compiler/CPU/optimization cells | 123,576 |
| Distinct compiler profile combinations | 66 |
| Compiler/ISA source rows with no enabled profiles | 0 |
| Historical P1 identities with owning harness | 67 / 67 |
| Historical P1 semantic construction covered/blocked | 56 / 11 |
| Frozen P1 batch construction covered/blocked | 48 / 11 |

The normal matrix now has 1,179 semantic, 1,139 codegen/ISA, 37
negative and three diagnostic sources. The 123,576 cells are
**scheduled/integrated**; they are not all executed in this report.
The source count includes 105 original PDP-10 C-to-instruction tests.

### Historical P1 integration

Thirty-eight unchanged original C source files that were formerly
covered only through independent companions are now also in the real
compiler matrix. Their original SHA256s, original covered/blocked
classification, and 66 CPU/family/compiler/optimization profiles are
pinned in `PDP10-P1-HARNESS-ORIGINALS-20261121-v1.tsv`. Existing
source profiles are left as they were. The newly admitted originals
are labelled `semantic-p1-original-observation` when their original
execution is meaningful, or `codegen-p1-original-observation` when
they only have a compilation/nonasserting oracle. Both forms retain
all real source failures. Neither is a retroactive semantic PASS.

Two checked source-selection lists are available:

- `PDP10-P1-HARNESS-OBSERVATIONS-20261121-v1.txt`: 38 newly added
  C source paths
- `PDP10-P1-HARNESS-ALL-C-20261121-v1.txt`: 66 current C owners
  corresponding to 67 historical P1 identities

The absent historical `old.tort.c` remains mapped through its single
already-reviewed SHA256-pinned native-width byte-pointer replacement.
The unchanged KL10 MACRO-10 `920428-1.s` remains a distinct **enabled
assembler/ISA special suite**, never a spurious PDP-6 C source.
Its historical unsupported DEFINE/link/guest failure is still
reported and does not block an ICE-only C compiler sweep.

`tools/audit-p1-original-harness-v1.py` verifies all 67 identities,
the existing original source SHA256s, exact original matrix admission,
all selected compiler cells, the separate ISA owner and both lists.
`--integrate --write` is an idempotent intentional integration mode;
normal verification does not alter files. Existing deferred and P1
history stays untouched at **56/11**. The canonical upstream
consolidation auditor accepts only these exact observation admissions,
not a general arbitrary deferred-source exception.

### Previously unreachable ISA and VLA tests

The 105 `tests/isa/pdp10-insn/*.c` C-to-instruction tests were
registered in `COMPILER_MATRIX.tsv` with `group=isa` and `isa` values,
but the runner ignored that group and status entirely. The runner
now maps it into **codegen**, retaining all original valid target/CPU
restrictions. The 105 exact source SHA256s, active column counts and
source list are pinned in `PDP10-ISA-C-HARNESS-20261121-v1.tsv` and
`PDP10-ISA-C-SOURCES-20261121-v1.txt`.

Two `tests/codegen/kcc-ported/vla-*.c` sources contain real runtime
assertions, but were labelled codegen while their 36 enabled matrix
column values said `semantic`. They were therefore silently omitted.
Only their matrix **group** is reclassified to
`semantic-kcc-ported-vla`. Neither source nor assertion changed.
The runner now also rejects ignored/missing active statuses in
`--list-only` and real execution, making this omission detectable.

## ICE-only exit policy without falsifying results

`tools/run-tests.py` (called by `./run-tests.sh`) accepts:

```
--exit-policy strict
--exit-policy ice-only
--source-file PATH
```

Default remains `strict`. `ice-only` never changes a stored status;
it makes these genuine defects **nonfatal for process exit only**:
`compile_fail`, `link_fail`, `run_fail`, `timeout`, and
`unexpected_compile_success`. They remain in `cells/*/status`,
`failures.tsv`, and the true `fail=` count in `summary.txt`. The
separate `exit_fail=` count drives the selected process exit policy.

Real `compiler_ice`, `setup_fail`, `policy_fail`, unknown statuses,
`running`, `not_run`, absent matrix sources, and ignored matrix
statuses still cause a failing process exit. A disappeared cell
cannot masquerade as an ordinary ignorable compiler failure.
`--source-file` selects exact registered paths without altering the
compiler matrix, and rejects an empty, duplicate, unregistered or
unsafe source selection. Old restart and strict-mode semantics remain.

The original compiler ICE matcher was also corrected: a bare
`ice-only` **output pathname** in a logged GCC command previously
matched the loose `\bICE\b` regex and falsely classified normal
missing-header errors as a compiler ICE. A bare word ICE is now
accepted only as an actual diagnostic; traditional GCC/KCC internal
error strings and compiler signals retain their ICE classification.

## Actual native PDP-6 acceptance: 175 observed cells

| Source slice | PASS | Compiler ICE | Other real failures | Total |
| --- | ---: | ---: | ---: | ---: |
| 38 newly added originals, GCC O0 | 15 | 1 | 22 | 38 |
| 38 newly added originals, KCC noopt | 11 | 0 | 27 | 38 |
| Enabled ISA C-to-opcode cases, KCC noopt | 99 | 0 | 0 | 99 |
| **All actual observed cells** | **125** | **1** | **49** | **175** |

The genuine GCC ICE is the unchanged original
`tests/semantic/upstream/extensions/991228-1.c`, GCC PDP-6 O0:
`Internal compiler error in instantiate_virtual_regs_1`,
`function.c:4444`, source line 14. This retains a fatal ICE-only
exit. Non-ICE GCC failures are 15 guest `run_fail`, three real
`link_fail`, and four actual timeout. Non-ICE KCC failures are 18
`compile_fail`, four `link_fail`, four guest `run_fail`, and one
timeout. All 99 native KCC PDP-6 applicable ISA codegen cells pass.

Separate real runner controls verify that GCC `990826-0.c` with a
missing `math.h` stays `compile_fail`, raw `fail=1`, `exit_fail=0`,
while historical GCC ICE `930120-1.c` at O1 stays `compiler_ice`,
raw `fail=1`, `exit_fail=1`. The newly reactivated VLA runtime
test passes KCC noopt and genuinely fails at runtime with GCC O0;
neither outcome is hidden.

Every observation is source/target/compiler/status SHA256-pinned in
`PDP10-HARNESS-NATIVE-OBSERVATIONS-20261121-v1.tsv`. The companion
`refs/p10tk-harness-native-observations-20261121-v1.tar.gz` contains
**582 raw compiler/status/assembly/map/SIMH records**, SHA256
`4da19df1011d4e86bf6d340cbcc11bb295da73ace3d0b06d159582d35be60fc3`.
`tools/audit-harness-integration-evidence-v1.py` validates native
source and compiler SHA256 identities, original status classes,
genuine ICE diagnostic, real guest PASS and all archived file hashes.
`tools/test-harness-integration-evidence-v1.py` adds 14 fail-closed
mutation controls. Old historical defect snapshots remain intact.

The standalone native KCC five-phase FP36 link/staging script was
already source-owned but not registered in the special dispatcher.
It is now explicitly registered as a **manual** validation root,
with reviewed source/id/group ordering in
`PDP10-MANUAL-ROOTS-20261121-v2.tsv`. Its external `KCC_REPO` and
`DAIMOS_REPO` prerequisites are not synthesized; its source and
original manual-root v1 contract are unchanged. The registered
special suite dispatcher tests require exactly all 22 manual roots.

## Commands and remaining execution scope

From `pdp10-testkit`:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
python3 tools/audit-p1-original-harness-v1.py
python3 tools/audit-isa-c-harness-v1.py
python3 tools/audit-harness-integration-evidence-v1.py
python3 tools/test-harness-integration-evidence-v1.py
python3 tools/test-harness-ice-only-v1.py

./run-tests.sh --list-only --compiler all --family all --cpu all \
  --opt all --exit-policy ice-only

./run-tests.sh --source-file \
  manifests/PDP10-P1-HARNESS-ALL-C-20261121-v1.txt \
  --compiler all --family native --cpu pdp6 --opt all \
  --exit-policy ice-only --out-dir "$TMPDIR/p10tk-p1-all-native-v1" -j 2

# To run all 123,576 registered compiler/CPU/profile cells instead,
# omit --source-file, --family, --cpu and --opt. The full run is not
# claimed in this document; use a stable --out-dir for restartability.
```

The complete sweep still needs actual execution. In particular,
registering a source or retaining a non-ICE failure does not validate
its semantic oracle or prove ISA opcode correctness. The KL10
MACRO-10 original retains its separate genuine harness dependency.
No compiler, assembler, DAIMOS kernel, historic source or guest
assertion was modified by this integration checkpoint.
