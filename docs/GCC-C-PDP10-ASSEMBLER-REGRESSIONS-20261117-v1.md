# PDP-10 GCC assembler regressions: original-oracle activation (2026-11-17 v1)

## Scope and source provenance

Two original historical GCC C regression sources from the retained
679-source audit are now active **assembler-output codegen tests**:

| Source identity | Required exact original regex | Forbidden original regex |
| --- | --- | --- |
| `gcc.dg/pdp10-local-char-word-boundary-1.c` | `POINT 9,\(0?17\),8` | `POINT 9,\(0?17\),17` |
| `gcc.dg/pdp10-lshr-subreg-plus-1.c` | `subi.*036` | `lsh.*-036\(` |

The first checks that the **fifth 9-bit character** of a local array
is accessed at offset 8 in the next 36-bit word rather than the
incorrect offset 17. The second checks that an unsigned logical
shift count is materialized using `subi ... 036` without the unsafe
combined indexed `lsh ... -036(...)` reload form. Both original
DejaGNU tests explicitly select `-O2` and `pdp10-*-*`.

The original files remain byte-for-byte unchanged in
`refs/gcc-c-unmirrored-v1/gcc.dg/`. The new active C sources in
`tests/codegen/gcc-historical-b12-v1/` preserve every byte of the
original C translation units and prepend only two native
`codegen-require-regex` / `codegen-forbid-regex` comment directives
per file. The original assertions and original SHA256 fingerprints
remain pinned in the batch review and source ownership ledger.

## Integration and matrix policy

The existing `tools/run-tests.py` codegen runner already compiles a
source to assembler using target GCC, then applies both required
and forbidden regex policies. Each new source uses **the existing
native mechanism**, not a separate fake compile-success check and
not an added compiler-driver workaround.

Exactly eight `pending` GCC optimization cells are added:

| Compiler target | Compiler flag | Byte boundary | Shift SUBREG |
| --- | --- | --- | --- |
| PDP-6 | `-O2 -march=pdp6` | pending | pending |
| KA10 | `-O2 -march=ka10` | pending | pending |
| KI10 | `-O2 -march=ki10` | pending | pending |
| KS10 | `-O2 -march=ks10` | pending | pending |

The two sources are **GCC-only**, because the exact emitted assembler
patterns, reload and GCC optimization regressions are not KCC
assembler equivalence assertions. All KCC, non-O2, base and generic
PDP-10 family matrix columns remain `no_test` for these two owners.

The original `docs/GCC-C-BATCH12-20261117-v1.tsv` is preserved as
an audit of the initial defer decision. The new
`docs/GCC-C-BATCH12-20261117-v2.tsv` changes exactly these two
source identities from `defer` to `integrate`, pins the new adapted
SHA256 and records the four GCC O2 profiles. No other batch12
source decision is modified. The static inventory verifier compares
v2 against every original v1 decision, audits the exact two policy
prefixes, and requires byte-for-byte original source bodies.
The six-token source-overlap index now reports 113 candidate shapes,
two more than before activation because these are real source copies.

Consequently the batch12 status changes from three pending / 25
deferred to **five pending / 23 deferred**, without changing the
22 inapplicable entries. The final 105-source integration status
becomes **12 pending / 68 deferred / 25 inapplicable**, including
these two activated oracles. The original 560 retained historical
source snapshots and 119 deletion tombstones are unchanged.

## Actual compiler and self-check results

The installed cross compiler is GNU GCC 3.2 experimental,
`pdp10-dec-none-gcc`, from `$PDP10_PREFIX/bin/`.
The generated assembler was checked using the real existing codegen
runner and its per-cell pass/fail checkpoint/policy machinery.

| Target | Fifth byte POINT | SUBI/LSH | Result |
| --- | --- | --- | --- |
| PDP-6 | `POINT 9,(017),8` | `subi 4,036` plus safe `lsh 1,0(4)` | PASS |
| KA10 | Same | Same | PASS |
| KI10 | Same | Same | PASS |
| KS10 | Same | Same | PASS |

**All eight real GCC compile-and-scan cells passed.** Each resulting
cell checkpoint reported `status=pass`, and each generated assembler
file independently satisfied both source policies. These results
were recorded in temporary, versioned `$TMPDIR/pdp10-asm-runner-v1-*`
checkpoints, not committed as permanent compiler test results.

To prove these are meaningful **fail-closed assembler checks**,
negative synthetic mutations of each emitted assembler were fed to
the same existing regex-policy evaluator:

* Byte case: replace the positive `POINT 9,(017),8` with
  `POINT 9,(017),17`. The missing required and matching forbidden
  policies both report failure, for all four targets.
* Shift case: replace `subi 4,036` with `subi 4,035` and insert
  `lsh 1,-036(4)`. The missing required and matching forbidden
  policies both report failure, for all four targets.

That gives **eight real compiler passes plus 16 expected negative
policy failure detections** (two predicates per mutated source and
target). No simulator, emulator, linker or runtime was used;
these are strictly compiler/assembler-output regressions.

## Reproduce in the standard testkit

The new tests are normal codegen matrix owners. The standard runner
will execute them whenever its selection contains the four target
GCC O2 cells, for example:

```sh
export TMPDIR=${TMPDIR:-$HOME/tmp}
mkdir -p "$TMPDIR"
./run-tests.sh --compiler gcc --family native \
  --cpu pdp6,ka10,ki10,ks10 --opt o2 --kind codegen
```

This runner selection includes **other registered GCC codegen tests**
for the same profiles, not just the two source files. The two new
rows can be identified by their `gcc-historical-b12-v1` source paths
in the per-cell status/log/assembler output under the runner's
configured `--out-dir`. For a policy failure, the runner writes a
`policy.report.txt` containing `missing_required_regex` and/or
`forbidden_regex_matches`, with the corresponding raw assembler
path. A source that merely compiles without producing the required
pattern cannot pass.

The four pre-existing, uncommitted negative-policy/runner changes in
the developer worktree are unrelated and were deliberately left
untouched and unstaged by this integration.
