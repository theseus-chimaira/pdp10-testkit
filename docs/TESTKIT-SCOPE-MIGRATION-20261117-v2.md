# DAIMOS/PDP-10 testkit ownership split (2026-11-17 v2)

## Required ownership boundary

`pdp10-testkit` owns GCC, KCC, DAS, DLINK, assembler, optimizer,
compiler ABI, code-generation, and standalone processor ISA regressions.
`daimos-testkit` owns the DAIMOS operating system: boot, disks,
filesystems, devices, shell, processes, services, and kernel runtime.

Ownership is based on the **primary assertion**, not on which tool sets
up a test. For example, a KCC backend test that compiles DAIMOS source
belongs to the compiler testkit; a D6FS mount test that assembles its
fixture belongs to the OS testkit. A native KCC/DAS/DLINK test that
uses a booted DAIMOS image **only as a test environment** still belongs
to the compiler/assembler testkit, but must be registered as a manual,
prerequisite-gated case. Do not execute such cases in an ordinary fast
compiler sweep, and do not weaken their native guest assertions.

## Versioned, SHA-pinned transfer

`docs/TESTKIT-SCOPE-MIGRATION-20261117-v2.tsv` enumerates exactly
**138 original file identities**, with source and destination paths,
original committed-file SHA256, owner before and after, and whether
an already-owned stronger/equivalent fixture made a copy unnecessary.

* **115** files: `daimos-testkit` -> `pdp10-testkit`, including 28
  existing/compiler-owned equivalents and 87 relocated files.
  Standalone KCC host and target suites, GCC character-pointer and
  heading regressions, `p10fold`, DAS DXR2 and DLINK XIP checks,
  and source/fixture pairs are now owned exclusively by PDP10.
* Of these, **59** files belong to native guest KCC/DAS/DLINK tests.
  Their assertions verify compiler/linker/assembler behavior, not the
  DAIMOS OS. All are registered as **manual** toolchain suites;
  boot-media and D6FS dependencies remain in the DAIMOS testkit,
  loaded through `DAIMOS_TESTKIT_REPO` (default sibling checkout).
  New compiler source paths resolve from this repository, and the
  original C/assembly fixture bytes are preserved.
* **23** files: `pdp10-testkit` -> `daimos-testkit`: DAIMOS-specific
  stage-one/PTR/TSFS boot, root media and snapshot validators,
  linked KCORE/MRES profile checks, and booted DAIMOS native DAS
  guest acceptance (C and runner). The source-level simulator/ISA
  fixture engine and generic PDP-10 opcode report tools remain here.

Four OS helpers in the destination were adapted to import generic
processor/ISA helpers through `PDP10_TESTKIT_REPO`, rather than
duplicating architecture code. The source/line/behavior assertions
are unchanged. The one original GCC `char-word-boundary` test uses a
byte-identical compiler fixture and its original shared standalone
startup assembly. `pdp10-gcc-multidim` reuses an existing identical
source already owned by the compiler testkit rather than retaining a
second source that can diverge.

One prior **mixed** regression was separated by assertion:
`daimos-testkit/tests/host/daimos-rm-recursive-kcc-clean-20261010-v1.sh`
still verifies OS `RM -R` and the removal of an obsolete DAIMOS RM
assembler command; `misc/kcc-host/kcc-native-make-clean-suffix-20261010-v1.sh`
now owns the independent native KCC suffix-rule, `CLEAN`, and
directory-qualified GNU Make assertions.

The earlier `v1.tsv` records the first smaller transfer and remains
unaltered. `v2.tsv` extends it by the 59 native compiler/assembler
suite files. The counterpart manifest in the DAIMOS testkit must
remain byte-for-byte identical.

## Registrations and static enforcement

Relocated standalone compiler/assembler scripts are in
`SPECIAL_TESTS.tsv`; heavy guest-native cases require explicit manual
selection. Existing KCC host and PDP-6 target cases with equivalent
or stronger coverage retain their canonical owner instead of being
scheduled twice. The corresponding helper scripts are owned in
`docs/TEST-SCRIPT-OWNERSHIP-20261116-v4.tsv`.

`tools/test-testkit-boundary-v1.py` checks the manifest counts, safe
paths, that neither original source path still owns a transferred
test, that all destination files exist, C/ASM fixture fingerprints,
and rejects known category violations. It is a registered `verify`
host test. `--require-cross` demands the actual DAIMOS testkit
checkout; normal host verification tolerates a standalone checkout.
Run `python3 tools/test-testkit-boundary-v1.py --require-cross` to
validate both repositories together. This does not execute an OS
or compiler sweep.

## Remaining scope and limitations

The DAIMOS OS testkit's many guest/runtime scripts are not automatically
compiler tests merely because they invoke DAS or KCC. They continue
to have operating-system owners. The older cross-repository TODO about
dynamic call-graph ownership of all OS scripts remains open until
every indirect/parameterized caller is audited; a static filename
transfer cannot establish that every OS test has actually executed.

No compiler, assembler, emulator, KCORE/MRES, filesystem implementation,
or historical test expectation was changed. Full compiler/OS sweeps
remain operator-controlled. SHA-pinned originals and normal Git history
are preserved rather than creating empty or fake replacement tests.
