# GCC PDP-10 target shell oracles: static ownership (2026-11-16 v3)

**Integration only; no compiler, assembler, or guest tests executed.**

The old DejaGNU tree was intentionally removed from current `gcc-pdp10`
at revision `b2649d1`. Its original sources remain in Git revision
`b0f5374`. The 18 applicable target-specific artifacts were copied
under `refs/gcc-pdp10-target-v2/` before removal. Twelve independent
C codegen oracles are already owned by the enabled
`gcc-target-codegen-v2` validation registration.

The four original shell oracles required separate decisions:

| Original reference | Canonical owner / disposition | Preserved assertion |
| --- | --- | --- |
| `bare-dlink-libgcc.sh` | Existing registered `badl-tables`, **equivalent, not rescheduled** | GCC generates `%BADL9`, passes its own archive to the linker, and resolves byte-pointer helpers; the canonical test additionally checks five BADL helpers and real PDP-6/KA10 execution |
| `libgcc-badptr-octal.sh` | New `gcc-target-badptr-octal-v3`, enabled `validation` | Source block in `gcc/config/pdp10/libgcc1.s` contains octal PDP-10 words, not decimal numeric data |
| `libgcc-empty-static-members.sh` | New `gcc-target-static-members-v3`, enabled `validation` | `gcc/config/pdp10/t-none` excludes `_eprintf` and `_bb`, retains `__gcc_bcmp`, and `gcc/mklibgcc.in` filters `LIB2FUNCS_ST` |
| `wide-int-mode-options.sh` | New `gcc-target-wide-macros-v3`, enabled `validation` | GCC's 71/72-bit options expose the correct mutually exclusive `__LONG_LONG_*` macros and each emits nonempty assembly |

The three new wrappers select **explicit current paths** and delegate to
the original unchanged `.sh` reference oracle. They do not copy the
oracle into a second implementation or rerun it through the independent
GCC Makefile. `GCC_REPO` may select a nondefault GCC checkout for the
two source-inspection oracles; the default is `../gcc-pdp10`.

The old `libgcc-empty-static-members.sh` assumes a DejaGNU-era
`srcdir` layout. The current files are not missing: they exist under
`gcc-pdp10/gcc/config/pdp10/t-none` and `gcc-pdp10/gcc/mklibgcc.in`.
Its wrapper sets `srcdir` to that `gcc/` directory. Similarly, the
bad-pointer table is read from `gcc-pdp10/gcc/config/pdp10/libgcc1.s`,
and the wide-mode macro input is the retained
`refs/gcc-pdp10-target-v2/wide-int-mode-macros.c`.

The fourth original script is deliberately not registered separately:
`misc/validation/test-badl-tables.sh` already checks its driver-link
and `%BADL9` assertion and more, including both PDP-6 and KA10 guest
execution. Adding the old shell invocation would double-count the
same driver contract without an independent observable result.

The unrelated historical `its-circ-1.c` was intentionally excluded
because ITS CIRC is not an applicable generic DAIMOS requirement. The
source remains accessible in Git history, but no synthetic non-ITS
test has been substituted for it.

The five historical shell scripts under `refs/` include a separate
assembler smoke. Its old `--start`/`deposit` interface has been replaced
by an enabled `das-reference-assembly-v5` fast test using current
binary DXR output, FP/byte-pointer fixtures, and a byte-for-byte
inline-versus-`.include` image comparison. This assembler migration is
also **unexecuted** at this stage.

The static script-ownership ledger records these reference-script
delegations and the two reviewed assertion replacements. The
upstream GCC C feasibility queue remains open beyond these 18
target-specific artifacts. Integration status is not test PASS status.
