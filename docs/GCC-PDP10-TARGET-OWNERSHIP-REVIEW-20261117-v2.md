# Original GCC PDP-10 target assertions: 19-source crosswalk (2026-11-17 v2)

The source-by-source original assertion and canonical executable owner
for all **19** historic `gcc.target/pdp10` artifacts are in
`docs/GCC-PDP10-TARGET-OWNERSHIP-20261117-v2.tsv`. This augments the
preserved original 19-row feasibility review, without rewriting its
conclusions or original GCC source bodies.

## One assertion owner per original artifact

| Artifacts | Ownership | Result from current installed tools |
| --- | --- | --- |
| **12 independent GCC C codegen cases** | `misc/validation/test-gcc-target-codegen-v2.py` | **12/12 pass**, with original compiler options and assembler positive/negative patterns |
| `libgcc-badptr-octal.sh` | `misc/validation/test-gcc-target-badptr-octal-v3.sh` | PASS, original octal BADL table spelling |
| `libgcc-empty-static-members.sh` | `misc/validation/test-gcc-target-static-members-v3.sh` | PASS, original t-none / mklibgcc build-policy assertions |
| `wide-int-mode-options.sh` | `misc/validation/test-gcc-target-wide-macros-v3.sh` | PASS, TEST_71/TEST_72 macro selection and nonempty assembly |
| `bare-dlink-libgcc.sh` | Existing stronger canonical `misc/validation/test-badl-tables.sh` | PASS, direct GCC driver link, all five BADL helpers, PDP-6 and KA10 guest checks |
| `bare-dlink-libgcc-1.c`, `wide-int-mode-macros.c` | Accompany their matching above-mentioned shell owners | Never scheduled standalone; bare C invocation would not exercise the whole oracle |
| `its-circ-1.c` | Explicitly inapplicable ITS-only CIRC source | Deleted from live tree; no fabricated generic test |

The 12 codegen cases include BLT byte-to-word effective addressing,
word-count BSS reservation, full SIXBIT/char6 representation,
cross-word packed bitfield stores, octal DAS immediates and ADJBP,
base-mode stack instructions, unsigned division branch offsets,
and 71-bit conversion. The native codegen runner verifies its
source-specific *required and forbidden* assembly patterns; the
71-bit conversion case was originally a compile-only regression
and remains compile-only. All 12 pass using installed GCC 3.2.

The three separately registered shell wrappers execute the original
historical shell oracles from `refs/gcc-pdp10-target-v2/`, not a
second, weaker reimplementation. The fourth shell assertion is
covered by the already registered, stronger `badl-tables` test, which
also executes the real PDP-6 and KA10 simulators. The BADL harness
had an environment defect: it required `SIMH_PDP6` and `SIMH_KA`,
which the standard `pdp10_setup_env` never exported. The harness now
defaults to `$PDP10_PREFIX/bin/pdp6` and
`$PDP10_PREFIX/bin/pdp10-ka`, matching the installed `p10run`
emulator selection, while preserving explicit candidate overrides.
The real BADL test subsequently **passed on both processors**.

The fail-closed `tools/audit-test-inventory-v1.py` verifies all 19
original identities and pinned hashes, a single enabled canonical
owner for each retained source, all 12 actual CASES in the native
codegen runner, exact original `dg-options` strings and original
required/forbidden scan counts (including the three equivalent
forbidden octal alternatives). It requires that the three shell
wrappers still reference their preserved original shell sources and
that neither companion is given an independent new registration.

**No GCC, KCC, libgcc or simulator implementation was changed.** The
work was test ownership, executable assertion validation, and a
missing harness environment default. The 12 source oracles and four
shell contracts above were actually executed; the ITS-only source
remains explicitly excluded.
