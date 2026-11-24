# GCC unsigned SImode runtime repair: source-linked v17 results

Date: 2026-11-24

## Scope and preserved baseline

This is a focused correction inside the interrupted/restartable
`workdir/full-sweep-current` compiler matrix. The original Nov 23
partial baseline contained 1,059 `run_fail` statuses, but further
completed checkpoints existed by this investigation: the actual local
inventory was 52,600 records when the follow-up census was taken.
These are not interchangeable baselines. No unrelated failures were
reset or reclassified as passes.

## Root cause and implementation

The PDP-10 `DIV` instruction uses a positive 70-bit dividend formed
from an AC pair, but its low AC has only 35 payload bits. GCC emitted
`MOVE low,numerator; SETZ high,; DIV high,divisor`, silently losing
the top bit of a full unsigned 36-bit numerator.

For positive divisors, the backend now moves the numerator into both
ACs, logical-shifts the upper AC right by octal 43 (35 decimal) and
clears the high bit of the lower AC before executing DIV. The general
pattern keeps the unsigned high-divisor comparison, and its forward
branch offsets were adjusted for the longer positive-divisor sequence.
The fix is in `gcc-pdp10/gcc/config/pdp10/pdp10.md`; it does not use
extra result registers or a libgcc division helper.

Before changing the machine description, the generated assembly from
the original failing `runtime-reduce-udivsi3-libgcc.c` was tested with
this correction on PDP-6. After both arithmetic and branch offsets
were corrected, that guest test passed.

## Original failure reruns

The GCC backend was rebuilt and installed in `$HOME/cross`. The exact
three previously failing sources were selected through the official
matrix runner with `--compiler gcc --exit-policy strict -j4`:

| Source | Old run_fail | New PASS |
| --- | ---: | ---: |
| `tests/semantic/runtime/runtime-reduce-udivsi3-libgcc.c` | 36 | 36 |
| `tests/semantic/runtime/runtime-reduce-umodsi3-libgcc.c` | 36 | 36 |
| `tests/semantic/runtime/runtime-pattern-divmod-si-unsigned.c` | 36 | 36 |
| **Total** | **108** | **108** |

All 108 were actually rerun, not skipped on existing PASS checkpoints.
They compiled, linked and executed under the simulator. There were no
new failures in the selected set.

## Independent regression

The new source
`tests/semantic/regression/pdp10-unsigned-divmod-constant-v17.c`
is a C89 runtime regression with a volatile numerator and noinline
constant-divisor functions. It tests quotient/remainder for 97,
octal 0100 and 2 with both high-bit and small unsigned inputs. This
explicitly covers the immediate positive-divisor code path, rather
than relying only on the variable-divisor reducer source.

Its `COMPILER_MATRIX.tsv` entry registers 36 GCC semantic profiles
across base and PDP-10 target families and four machines. The official
strict runner executed all 36 new cells: **36/36 PASS**.

The runner's result-accounting test passes. The registered-fixture
integrity audit reports 607 scripts, 2,369 C sources and zero
problems. The full `--list-only` matrix has **124,091** cells after
registering this test; it is not a completed sweep.

## Current recorded checkpoint inventory

The read-only matrix census (after the new regression completed) was:

| Checkpoint status | Cells |
| --- | ---: |
| pass | 45,275 |
| compile_only | 3,144 |
| run_fail | 2,927 |
| compile_fail | 1,029 |
| link_fail | 138 |
| timeout | 119 |
| running | 4 |
| **Total recorded** | **52,636** |

The 2,927 remaining runtime failures are not claimed to have a single
cause; at least 119 distinct source identities are involved. Other
non-pass statuses remain separate and are not part of the v17 fix.
The next focused runtime family should be byte-pointer subtraction
and subword addressing, followed by structure-copy and return ABI
failures; all must be diagnosed with exact simulator/assembly evidence.

Versioned compiler backup and build logs are in
`$TMPDIR/pdp10-gcc-unsigned-div-v17/` on the build host.
