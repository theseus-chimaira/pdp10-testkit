> Historical 2026-11-17 split. Current ownership: `docs/TESTKIT-SCOPE-MIGRATION-20261119-v4.md`.

# Compiler/assembler versus DAIMOS OS test ownership (2026-11-17 v3)

The two testkits have one explicit boundary, determined by the actual
assertion being tested, **not by whether a compiler or an OS guest is
needed to set up the test**.

* `pdp10-testkit` owns GCC/KCC compiler semantics, diagnostics, ABI,
  code generation, DAS/DLINK assembler/linker formats, p10fold, generic
  PDP-10 tools and standalone ISA/processor tests.
* `daimos-testkit` owns DAIMOS boot, KINIT/KCORE/MRES execution,
  filesystem/mount/media state, device drivers, shell, syscalls,
  processes, services and kernel runtime.
* Native KCC/DAS/DLINK compiler validation *inside a booted DAIMOS*
  remains a compiler assertion. Such tests move to `pdp10-testkit` but
  are **manual** and use `DAIMOS_TESTKIT_REPO` exclusively to obtain
  their original OS bootstrap, distribution and guest SIMH harness.
  They are not executed as part of a generic compiler/codegen sweep.

## Exact source-owner changes

The source-path/SHA256 manifest
`docs/TESTKIT-SCOPE-MIGRATION-20261117-v3.tsv` contains **150 original
identities**, in exactly two directions:

| Former owner | New owner | Files | Resolution |
| --- | --- | ---: | --- |
| `daimos-testkit` | `pdp10-testkit` | 127 | 99 moved, 28 deduplicated against existing tests |
| `pdp10-testkit` | `daimos-testkit` | 23 | 23 moved with original OS assertions |

The compiler transfer includes 71 native-guest compiler/assembler
driver and fixture files. All retained original C and assembler
source bytes are unchanged. Native compiler runners were patched only
to address the original compiler fixture from this repository and
the DAIMOS OS guest environment from the other testkit. Standalone
KCC/GCC compiler scripts, DAS DXR2, linker XIP, p10fold, and ABI
regressions now have compiler-testkit registrations. The native
boot-backed cases are manually gated, not default suite participants.

The reverse transfer includes DAIMOS stage-one boot, PTR and TSFS,
D6FS disk media and linked-root validators, linked KCORE/MRES boot
profiles and the DAIMOS native DAS *guest execution* acceptance. These
are OS assertions, not standalone DAS instruction/format regressions.
The generic ISA fixture profiler and opcode engine remain here and
are imported from `daimos-testkit` without duplicating source.

The earlier **v1** (56 compiler and 23 OS transfers) and **v2**
(115 compiler and 23 OS transfers) are preserved in Git history,
not retained as competing active snapshots. This canonical v3 manifest
includes those records and the 12 additional native KCC phase, staged
Makefile, overflow and compiler-progress assertions.

## Mixed tests and special cases

The prior combined `daimos-rm-recursive-kcc-clean` test was split:

* `daimos-testkit/tests/host/daimos-rm-recursive-os-20261117-v1.sh`
  verifies recursive OS RM and the obsolete DAIMOS assembler RM path.
* `misc/kcc-host/kcc-native-make-clean-suffix-20261010-v1.sh`
  verifies native KCC `.S.DOBJ` inference and `CLEAN` Makefile rules.

The original mixed test's native KCC suffix check hardcoded the old
`/OPTION/BASE/EXEC/DAS` command. Current `kcc/daimos.mk` instead binds
`NATIVE_DAS = DAS` and uses `$(NATIVE_DAS)` in its suffix recipe. The
split compiler test checks the actual variable binding and recipe,
the unchanged no-per-object-rule and recursive-CLEAN requirements,
and the exact expanded `make -n` command. The focused native KCC
Makefile check passed; neither KCC sources nor expected behavior was
weakened to obtain that result.

GCC multidimensional-character source assertions were already owned
by a byte-identical fixture here. The relocated wrapper reuses that
fixture, rather than making another copy. The separate GCC stack-byte
boundary script received its original standalone CRT assembler
fixture without removing the shared OS CRT used by DAIMOS tests.

## Enforced static validation

`tools/test-testkit-boundary-v1.py` rejects missing destinations,
retained old-owner source paths, invalid category placements, altered
C/ASM fixture bytes and manifest changes. Its `--require-cross`
option explicitly demands both repositories. It is registered under
the PDP10 host `verify` suite; the DAIMOS Makefile exposes the same
cross-repository check through `make test-testkit-scope-v1`.
`tools/audit-test-inventory-v1.py` and
`tools/audit-script-ownership-v4.py` retain exact matrix/entrypoint
ownership and manual/delegated script accounting. The DAIMOS OS
Makefile no longer owns the transferred compiler tests; host OS
assertions and operator-selected OS boot tests retain explicit targets.

No full sweeps are run by this preparation. Further exhaustive audit
of **dynamically dispatched** DAIMOS OS scripts (and actual suite
execution) remains a separate open item; static ownership is not a
claim that every such OS test has been executed.

## Documentation cleanup (2026-11-17)

The active README and TODO refer to this canonical v3 report and
manifest. The intermediate migration v1/v2 Markdown/TSV documents were
removed from the working tree because all 150 original file identities
are now present in the v3 manifest. Their exact earlier forms remain
recoverable from Git history. The historical DAIMOS-specific AAP kernel
coverage document is now maintained under
`../daimos-testkit/tests/validation/DAIMOS-AAP-KERNEL-COVERAGE-MATRIX-20261117-v2.md`.
Older timing studies retain their dated measurements but now point to
OS-owned source/profile helpers in `daimos-testkit`.
