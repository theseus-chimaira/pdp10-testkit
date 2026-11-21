# PDP10 standalone manual runtime sweep - 2026-11-19 v1

## Scope

All 19 manually gated `SPECIAL_TESTS.tsv` roots were individually
selected using the installed PDP-10 tool prefix and sibling DAIMOS,
KCC, DAS and PDP-6 emulator source trees. The native DAIMOS guest KCC
compiler bugs are deferred; no compiler/assembler/optimizer production
source or original C test assertions were changed by this sweep.

The default matrix and full OS regression were not run. Diagnostics
that intentionally investigate a disputed oracle are not clean
acceptance gates. The results below are actual invocations, not mocked
dispatch checks. Individual test logs are preserved under
`$TMPDIR/pdp10-manual-*-20261119-v1.log`; other retained scratch
artifacts are called out below.

## All 19 registered manual roots

| ID | Result | Observation |
| --- | --- | --- |
| `das-dxr2-st2-v1070` | PASS | Seven ST2/TX2 cases |
| `p10fold-io-skip-v1` | PASS | Five skip-sensitive patterns and control |
| `kcc-host-make-split-v1` | PASS | Staged native KCC Makefile graph |
| `kcc-host-stage-readonly-v1` | PASS | Read-only stage replacement |
| `kcc-rm-codegen-v1` | PASS | Native RM cross-compilation |
| `kcc-foldtrna-codegen-v1` | PASS | Conditional assembly/codegen |
| `kcc-preserved-arg-codegen-v1175` | PASS | Preserved argument across call and store |
| `kcc-excluded-directive-v1070` | PASS | Excluded long directive ignored safely |
| `gcc-kcc-backend-20261012-v1` | PASS | Four GCC/DAS backend cases |
| `linker-xip-format-v218` | PASS | Valid XIP image and negative eligibility cases |
| `das-build-das-native` | PASS | Native DAS driver/phase1/phase2 build and contracts |
| `deferred-libc-probe-v1` | PASS | Explicit `20000910-2.c` source: KCC -n and GCC -O0 pass |
| `freestanding-search-benchmark-v1` | PASS | Six assembler/reference instruction-step measurements |
| `p10fold-local-section-v1141` | FAIL | Fold plan incorrectly merges distinct LOCAL text targets |
| `kcc-indptr-call-v1395` | FAIL | Expected call-safe indexed store lost in KCC output |
| `kcc-kinit-adjsp-codegen-v1` | BLOCKED | KINIT Makefile cannot create stack-mode stamp prerequisite |
| `aap-illegal-relocation-diagnostic-v1` | FAIL | AAP cpustatus timeout on ordinary JRST control |
| `kcc-pdp6-rounded-fp-boundaries-v2` | FAIL (known diagnostic) | Octal case 011 differs from 030 expected by mathematical oracle |
| `kcc-aap-pdp6-rounded-fp-v2` | FAIL (known diagnostic) | Same octal case 011 vs 030 discrepancy |

**Total: 13 PASS, 6 not passing.** One of the six is a missing
build prerequisite and two are deliberately retained mathematical
floating-point diagnostics. No failure was converted into a PASS.

## Repaired manual dispatch and DAS build interface

The DAS manual root was previously blocked because the dispatcher
required suite preparation even though `build-das-native.sh` is
self-contained. Exact-ID selection now permits that one manual DAS
root, retaining the separate guard against nested DAS helpers. The
DAS wrapper also used obsolete Makefile argument names, output paths
and a deleted DAIMOS `cross/tools/mkdex0r_user.py` sentinel.
It now checks the real DAIMOS libc source and uses the current DAS
`NATIVE_BUILD_DIR`, `PDP10_KCC`, and `PDP10_DLINK` interfaces.

The successful native DAS build measured these image/process limits,
in **octal words**:

| Image | Image | Process |
| --- | ---: | ---: |
| Driver | `000765` | `002765` |
| Phase 1 | `033233` | `037265` |
| Phase 2 | `027751` | `033474` |

These are host-built native target images; this test did not boot
DAIMOS or execute DAS inside the guest. The build/validator reported
`native DAS phase-chain contract passed`.

The deferred-libc helper requires an explicit test source. Its manual
selection now requires `PDP10_DEFERRED_LIBC_SOURCE` and forwards that
value to the existing `--source` argument. Without the variable,
selection fails closed rather than silently choosing a source.
The actual two-cell run used:

```
PDP10_DEFERRED_LIBC_SOURCE=tests/semantic/upstream/generic/20000910-2.c \
    ./run-special-tests-v1.sh run deferred-libc-probe-v1
```

Both KCC/PDP-6/noopt and GCC/PDP-6/O0 cells passed. This does not
activate any deferred source in the ordinary matrix.

## Independent search benchmark

The six measurements use the same KCC no-optimization workload and
differ only in the assembler library versus C reference implementation.
These are **SIMH instruction steps to HALT**, not elapsed-time or AAP
logical-tick measurements:

| Routine | Assembly steps | C-reference steps | C/assembly step ratio |
| --- | ---: | ---: | ---: |
| `strstr` | 71,243 | 198,011 | 2.78 |
| `strpbrk` | 54,315 | 132,123 | 2.43 |
| `strspn` | 21,771 | 42,939 | 1.97 |

Raw values: `$TMPDIR/p10tk-search-benchmark-v1/results-v1.tsv`.

## Open investigations; production code unchanged

- `p10fold-local-section-v1141`: installed P10FOLD and the DAIMOS
  built host binary are byte-identical. The test observed an unsafe
  `FOLD` plan between two separate local-section objects. Retain the
  negative linker/fold-plan assertion and investigate the optimizer.
- `kcc-indptr-call-v1395`: KCC generated `movem 1,0(2)` after a call
  where the test requires safe loop index handling. The actual
  assembly is in `$TMPDIR/kcc-indptr-call-v1395/`.
- `kcc-kinit-adjsp-codegen-v1`: DAIMOS kernel Makefile reports no rule
  for `.kinit-stack-v655-0400-0` before KCC can run. The rule target
  expands the stack-watermark variable before the current declaration;
  investigate and correct the build graph in DAIMOS, not by bypassing
  this prerequisite in the testkit.
- `aap-illegal-relocation-diagnostic-v1`: the AAP console helper reports
  a missing `cpustatus` reply on an expected ordinary-JRST HALT
  control. This is an unresolved emulator/harness diagnostic, not proof
  of PDP-6 instruction semantics.
- Both rounded-FP manual suites retain the already known case-9
  mathematical-versus-hardware disagreement. See
  `history/PDP6-FP-SIMH-FIDELITY-20261021-v1.md`.

These investigations do not change the completed testkit ownership
split or promote the 19 manual tests to default automatic coverage.
