# PDP-10 C89 pointer canonical-comparison repairs (2026-11-21, v2)

## Verified KCC compiler defect and repair

KCC commit `4a61c53` repairs a real optimized compiler register
liveness defect in `ccgen2.c:gboolop()`. After the earlier commit
`46d0181` correctly made `void *`-to-`void *` a representation-
preserving no-op, the real PDP-6 optimized compiler still generated
a pointer equality comparison against a scratch S-field register.

The exact C89 three-argument regression
`tests/semantic/regression/pdp10-halfptr-multiarg-identity-v1.c`
captures both input and returned native S=18 pointer words around
an indirect `void *` identity call. Before the v2 fix, the real
PDP-6 simulator recorded both words as octal `002200002402`,
yet KCC opt failed pointer equality with ID 12. KCC noopt and
all four GCC profiles passed the independent source.

The cause was successive `gptrcanoncmp()` calls using labels and
scratch accumulators: the second canonicalization reused a physical
accumulator holding the first canonicalized operand. The compiler
now saves the first operand in one transient stack word while
canonicalizing the second, then restores both live VREGs and cleans
up the stack **before** emitting the conditional skip. This is a
correct compiler-level liveness fix, not a test workaround; it adds
no static/global RAM, heap allocations, or runtime ABI helper.

The installed KCC compiler now has SHA256
`b189271f7a43496eaa60dcdfa540ce0a363dae72f8d833273f022eb85ac7a19a`.
The earlier KCC compiler SHA256
`72f5d94c9a3fd21481928d9b47caa1451dfcd9bd61937f63da5b08c2f04b9fa6`
and the intermediate v1 correction
`b60e6172ee6ebf90a9d316572f99319873fca7fba14818161fc993b11aa4fd34`
are preserved in versioned backup files. The frozen old v1 raw
evidence is authenticated independently and remains immutable.

## Native PDP-6 results (actual guest executions)

| Source | GCC O0/O1/O2/Os | KCC noopt | KCC opt |
| --- | --- | --- | --- |
| `pdp10-void-pointer-roundtrip-locator-v1.c` | 4 PASS | PASS | PASS |
| `pdp10-halfptr-multiarg-identity-v1.c` | 4 PASS | PASS | PASS |
| `pdp10-byte-pointer-torture-v1.c` | 4 run_fail (21/28/28/28) | run_fail decimal ID 10 | **PASS** |

Both small sources have real 9/18/36-bit object data assertions,
an indirect volatile function-pointer boundary, and pointer identity
checks; neither source bypasses the compiler runtime. The larger
source is the existing active C89 replacement for the deleted
historical `old.tort.c`, *not* a new import of that original.

The 18 cells consist of **13 real native guest PASS and five
genuine run_fail**. The versioned evidence manifest
`PDP10-P1-BYTE-POINTER-CANONCMP-EVIDENCE-20261121-v2.tsv`
pins all source SHA256s, exact compiler/core libc identities and
statuses. Raw archive
`refs/p10tk-p1-byte-pointer-canoncmp-20261121-v2.tar.gz`
contains **90 real guest artifacts** (compiler logs, asm, maps,
SIMH reports, status). Its SHA256 is
`2f60a8b462b7889307d4f188122eaac6ed2ebb8d512b4c23fcc4b010a9676cad`.

`tools/test-p1-byte-pointer-canoncmp-v2.py` is a strict offline
validator (seven mutation controls). It also regenerates evidence
from the exact three versioned executed normal-matrix directories
with `--write`. The historical v1 evidence validator still passes
and retains the two earlier KCC failures; no old failures have
been retroactively reclassified.

The three existing real KS10 KCC/GCC direct, nested, and stack-call
ABI scripts pass, and the previously closed native 71-bit historical
`conversion.c` evidence remains authentic.

## Still open and next steps

KCC noopt still has a **distinct** identity failure at decimal ID 10
in the larger pointer-torture source, despite passing both new focused
oracles. The SIMH report displays `000000000012` in octal; this is
decimal 10, **not** decimal 12. A minimal follow-up with a 9-bit
check before the 18-bit check confirms that noopt aborts in the
**first 9-bit check**, before calling the halfword checker. Physical
PDP-6 register inspection at its pointer compare records the
native S=9 pointer `001100002503` versus `000000001511`, a word
address derived from transient stack state. KCC noopt is failing
to preserve the incoming byte pointer through its indirect call.
GCC O0 still fails at ID 21 (9-bit readback); GCC O1/O2/Os
still fail at ID 28 (18-bit array stride). These three compiler
behavior groups require actual owning code fixes.

The historical `old.tort.c` P1 source is **not** marked covered.
The live ledger is still **56 covered / 11 blocked** original
sources (48 covered / 11 blocked frozen batch positions). The
full compiler/CPU/optimization sweep remains prohibited until all
eleven outstanding original-source construction slots are closed.
