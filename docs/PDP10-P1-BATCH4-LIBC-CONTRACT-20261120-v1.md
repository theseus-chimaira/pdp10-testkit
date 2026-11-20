# P1 Batch 4: exact libc and conversion runtime contracts (v1)

Date: 2026-11-20. Only the two original C sources in Batch 4 slots
3 and 4 were executed, each on KCC PDP-6 noopt and GCC PDP-6 O0.
No original file, guest oracle, compiler, installed library or matrix
registration was modified. This is a targeted prerequisite probe, not
the general compiler/CPU sweep.

## Installed toolchain results

| Original source | KCC noopt | GCC O0 |
| --- | --- | --- |
| `tests/todo/generic/991112-1.c` | `link_fail`: `isprint` | `link_fail`: `isprint` |
| `tests/semantic/upstream/pdp10/pdp10/conversion.c` | `run_fail` | `link_fail`: `__fixunssfsi` |

`991112-1.c` invokes `isprint` through the indirectly called
`rl_character_len` function. Both compilers generate an external call.
The actual PDP-10 linker reports `dlink: undefined symbol: isprint`.
The original test checks the printable letter 'a' and nonprintable
octal-002 control character; neither assertion was weakened.

`conversion.c` tests signed/unsigned conversions involving int,
long long, float and double. GCC emits a reference to
`__fixunssfsi`, which the actually selected freestanding runtime
members do not provide. The real linker reports that exact undefined
symbol. KCC does not need this missing symbol in the observed PDP-6
noopt cell: it links, HALTs, and leaves `__test_exit=1`. This is a
separate execution failure, not a missing-symbol diagnosis.
The original's `sizeof(double)>=8` gate must not be rewritten or
interpreted as universal coverage of PDP-10 double conversions.

The audit checks *selected installed runtime sources*, including
KCC/GCC freestanding assembly members and KCC runtime fragments.
Absence in those sources does not prove the symbol is unavailable in
every future hosted libc or unlinked target archive.

## Reproduce exact bounded evidence

```
export TMPDIR="${TMPDIR:-$HOME/tmp}"
python3 tools/probe-deferred-libc-v1.py \
  --source tests/todo/generic/991112-1.c \
  --source tests/semantic/upstream/pdp10/pdp10/conversion.c \
  --compiler all \
  --outdir "$TMPDIR/p10tk-p1-batch4-libc-contract-20261120-v1"
python3 tools/audit-p1-batch4-libc-contract-v1.py \
  --results "$TMPDIR/p10tk-p1-batch4-libc-contract-20261120-v1/results-v1.tsv"
```

The source-SHA-pinned result snapshot is
`docs/PDP10-P1-BATCH4-LIBC-CONTRACT-20261120-v1.tsv`.
The host-only `tools/test-p1-batch4-libc-contract-v1.py` exercises
six negative controls: falsely passing a cell, clearing a missing
symbol, altering a source SHA, duplicating a compiler identity, and
injecting either presently missing symbol into the selected exports.

The optional evidence audit also checks exact PDP-6 compiler profiles,
linker diagnostics for both unresolved symbols, and the completed
HALT/nonzero `__test_exit` for KCC conversion. If new runtime members
provide a symbol, the auditor fails closed and demands a fresh probe
rather than silently accepting stale blocker evidence.

Both original sources remain blocked in P1 semantic resolution v8.
No compiler defect was fixed and no fake libc routine was introduced.
