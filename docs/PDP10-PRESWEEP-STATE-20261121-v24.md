# PDP-10 testkit current ICE-focused harness state (v24)

Date: 2026-11-21. Supersedes v23 as the current harness integration
status. v23 remains the authentic historical semantic/ICE baseline.

| Current measure | Value |
| --- | ---: |
| Compiler matrix sources | **2,358** |
| Special tests (enabled / manual) | **412 (390 / 22)** |
| Owned script files | **585** |
| Scheduled compiler/CPU/optimization profile cells | **123,576** |
| Compiler profiles | 66 |
| Inactive/unowned or incorrectly ignored registered source rows | **0** |
| Historical P1 sources with a harness owner | **67 / 67** |
| Historical P1 semantic covered / blocked | **56 / 11** |
| Frozen P1 batch covered / blocked | **48 / 11** |

## Runner policy change requested by the project

The user explicitly prioritizes **integrating all tests and finishing
the harness**, ignoring ordinary compiler/runtime defects **except
ICEs**. That is now implemented as the opt-in
`./run-tests.sh --exit-policy ice-only` policy. The strict default
is unchanged. Real compiler syntax, link, runtime, and timeout
failures still remain in `failures.tsv`, per-cell checkpoints and
raw `fail=` counts, but do not cause ICE-only process failure.
Actual `compiler_ice`, testkit setup/policy failures, missing
sources and incomplete/unknown cell statuses remain fatal and
visible in `exit_fail=`.

The old ICE matcher wrongly treated the word `ice` in an output
pathname as a compiler ICE. It is corrected, with real GCC missing
`math.h` and genuine source-located GCC 3.2 ICE execution tests.
The runner supports SHA/source-listed `--source-file` selections
and rejects any silently ignored or missing matrix cells.

## Integration changes

* **38** previously companion-only P1 original C sources now have
  separate source-pinned execution/compile observation matrix rows
  across all applicable compiler profiles; 67 historical P1
  identities now have verified harness owners. The historical
  `old.tort.c` replacement remains the sole approved missing-file
  mapping and the KL10 `920428-1.s` uses its separate ISA script.
* **105** previously invisible registered C-to-ISA instruction
  codegen sources are dispatched through their original `isa`
  compiler matrix statuses. The separate KL10 assembler fixture
  is not recast as a C test.
* Two runtime-asserting VLA tests formerly misclassified as codegen
  are now correctly scheduled as semantic tests: 36 formerly
  omitted compiler profile cells are reachable.

The additional registration raises the complete matrix to
**123,576 scheduled cells**; it has *not* all been executed.

## Executed native PDP-6 evidence, not a full sweep

The new versioned observation archive records 175 actual cells:
38 GCC O0 original observations (15 PASS, 22 ordinary failures,
one genuine compiler ICE), 38 KCC noopt originals (11 PASS, 27
ordinary failures, no ICE), and 99 KCC noopt ISA codegen PASS.

The **genuine ICE** is GCC O0 compiling unchanged P1
`tests/semantic/upstream/extensions/991228-1.c`, at line 14,
`instantiate_virtual_regs_1`. The ICE-only runner returns failure
for that case, not a false PASS. No attempt was made to fix its
ordinary semantic failures or change the source.

The evidence manifest `PDP10-HARNESS-NATIVE-OBSERVATIONS-20261121-v1.tsv`
and SHA256-pinned archive
`refs/p10tk-harness-native-observations-20261121-v1.tar.gz`
contain **582 real raw artifacts**, archive SHA256
`4da19df1011d4e86bf6d340cbcc11bb295da73ace3d0b06d159582d35be60fc3`.
Source and compiler fingerprint checks and 14 deliberate negative
controls pass. The genuine VLA guest runtime failure and all 49
ordinary original-source failures remain recorded as failures.

Details, exact source lists, command syntax and acceptance limits:
`PDP10-HARNESS-ICE-FOCUSED-INTEGRATION-20261121-v1.md`.

## Remaining scope

The testkit **integration gate is complete**; semantic correctness
is not. The previous v23 P1 original construction count 56/11
remains unchanged. Full 123,576-cell compiler/CPU/optimization
execution, and separate KL10 source realization, are outstanding
executions/development tasks, **not** missing harness ownership.
All raw non-ICE defects should be triaged later unless the user
changes priority. Continue ICE detection and running the registered
matrix with restartable output rather than rewriting test oracles.
