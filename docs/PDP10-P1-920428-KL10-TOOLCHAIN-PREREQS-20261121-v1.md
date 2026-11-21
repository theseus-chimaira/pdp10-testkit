# P1 920428-1.s: verified KL10 toolchain prerequisites, not P1 closure

Date: 2026-11-21. P1 frozen Batch 4, slot 8 is the unchanged
MACRO-10/KL10 upstream assembly source
`tests/semantic/upstream/support/920428-1.s`, SHA256
`747162b74215e1176b7031671da7d24012ffbaa508bbc3a6caf1f3fcc8f86ead`.
This is a dedicated KL10 assembler/ISA obligation, not a valid PDP-6
KCC/GCC C test. It **remains blocked** and has no verified native
KL10 guest PASS. P1 remains **56 covered / 11 blocked**, with
48/59 frozen source positions covered. The full CPU/compiler sweep
is still prohibited.

## Real defects repaired in the owning tools

**DAS MACRO-10 parsing** previously rejected the original
`BYTE (9)0` size-and-field syntax. The assembler's `byte_begin`
now accepts a parenthesized first field width while retaining
its established `BYTE 9,0` form and requiring widths 1..36.
The old parser also treated original `.DIRECTIVE KL10` as an
unknown pseudo-op. DAS now recognizes precisely this target
selection directive, verifies its spelled-out KL10 operand and
rejects conflicts with `-K`/strict base mode or unknown CPU
directives. It does not claim generic MACRO-10 macro support.

The two versioned ISA source fixtures
`pdp10-macro10-byte-directive-v1.s` and
`pdp10-das-byte-equivalent-v1.s` produce **byte-identical DOBJ**
with the real installed DAS. Unsupported `.DIRECTIVE KA10`
and contradictory strict-baseline `-K` variants fail closed.
The original upstream assembly now advances to the next real
unsupported feature: **`DEFINE`** (the nested MACRO-10 `OWGBP`/
`GIW` templates), which must be implemented with correct
`%ONE` relocation semantics, not ignored or replaced by a
different source program.

**DLINK unused external declarations** previously produced a
link error for `%ONE` despite the standalone DAS port DOBJ
containing no relocation to `%ONE` or `%BADX6`..`%BADXH`.
The linker now checks actual symbol relocation references when
deciding whether an undefined DOBJ symbol requires a provider,
and applies the same check during archive extraction. This
retains symbol-table provenance, avoids needless loading of
unused archive members, and allocates **no new RAM index**.
The positive test of six declared-but-unused externals links;
an independently assembled source with a *real* `%ONE`
relocation still fails exactly on undefined `%ONE`.

**P10RUN native result accounting** previously treated a KL10
`Step expired` guest as a PASS if its `__test_exit` memory word
was still zero from initialization, even though the guest never
completed the CRT termination path. The runner now rejects
both `Step expired` and `Time expired` as simulator failure
reasons before accepting observed memory expectations.
The unchanged previous KL10 syntax port now reaches link/run,
but the KL10 simulator exhausts its step budget at PC 000000
without a HALT. This is correctly **FAIL**, not a KL10
native semantic PASS. No test oracle is weakened.

## Explicitly unresolved original source

`tools/test-p1-920428-kl10-toolchain-prereqs-v1.py` executes all
these actual assembler, linker and KL10 simulator controls. It
also verifies the unchanged upstream source SHA and requires
its current `unknown op DEFINE` error to remain explicit.
The earlier separate syntax port assembly gate
`tools/test-920428-das-port-v1.py` is retained unchanged and
still makes **no native semantic-execution claim**.

The original's `DEFINE OWGBP`, `DEFINE GIW`, reference to `%ONE`,
`..main` ABI entry and global byte pointer/`XMOVEI`/`ADJBP`
instruction behavior still require genuine MACRO-10 compatibility
and KL10 guest execution. The existing DAS `GIW`/`OWGBP`
pseudo-ops are not evidence that arbitrary nested source
definitions have been expanded identically. In particular,
`GIW (Y)<<Y>*%ONE>` references a real external multiplier;
silently treating that expression as simply `Y` would change
the source semantics.

## Reproduction

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
python3 tools/test-p1-920428-kl10-toolchain-prereqs-v1.py
python3 tools/test-920428-das-port-v1.py
python3 tools/audit-test-inventory-v1.py
python3 tools/build-p1-semantic-resolution-v29.py
python3 tools/audit-p1-source-batches-v28.py
```

The current normal inventory recognizes all four new versioned
ISA source fixtures and their registered owning script. The
unrelated, separately committed `v1735`/`v1738` checks have now been
registered with their correct owning profiles. All three KS10
GCC/KCC ABI scripts ran successfully and are enabled. The DAS host
phase-pair test now uses an explicitly selected `DAIMOS_REPO` or the
real sibling DAIMOS checkout, failing rather than synthesizing a
stage1 fixture if that source is absent. Its installed driver/phase2
consistency check passes and is enabled. All script owners are
connected without changing the manually gated suite contract.
