# GCC historical C integration: batch 01 of 50 (2026-11-16 v1)

## Evidence and ordering

This batch reviews **exactly the first 50 unresolved** historical GCC C
sources in the order of `docs/GCC-C-UNMIRRORED-OWNERSHIP-20261116-v1.tsv`
before this batch. All 50 belong to `gcc.c-torture/execute`; 18 of them
are under its `ieee/` subdirectory. Original fingerprints trace to
GCC Git revision `b0f5374f6d4462bb8759160ece635e306d90998f`.
The 23 inapplicable snapshots from this batch were subsequently deleted;
retained originals remain in `refs/gcc-c-unmirrored-v1/`.
The deleted-source list and rejection rationales are recorded in
`docs/GCC-C-INAPPLICABLE-REMOVALS-20261117-v1.tsv`.

`docs/GCC-C-BATCH01-20261116-v1.tsv` is the per-file decision record:
original path and SHA-256, original assertion, native PDP-10 assessment,
disposition, adapted source path and SHA-256 if applicable, and the exact
reason. The static ownership audit verifies this 50-row crosswalk and the
absence of unregistered batch sources. Every original is accounted for.

**No tests were executed**: no GCC or KCC compilation, assembler, guest,
simulator, benchmark, or test runner. Static source inspection and
source-fingerprint verification are not compiler correctness evidence.

## Decisions

| Disposition | Number | Meaning |
| --- | ---: | --- |
| `integrate` | 17 | Meaningful original regression adapted for PDP-10, registered as pending |
| `defer` | 10 | Source retained; useful assertion or prerequisite needs additional work |
| `inapplicable` | 23 | Original assertion relies on another target or incompatible semantics |
| **Total** | **50** | No entries silently discarded |

The 17 sources under `tests/semantic/gcc-historical-b01-v1/` are:

| Regression | Preserved PDP-10 oracle |
| --- | --- |
| `20000314-2.c` | Wide integer constant through conditional return |
| `20000402-1.c` | Constant and volatile/runtime wide unsigned division giving 40 |
| `20000523-1.c` | Variable and constant high-bit shift followed by signed division |
| `20000818-1.c` | Termination of original lexer loop on zero input |
| `20001203-1.c` | Long/char local aggregate initializer, observed through a volatile write |
| `20011115-1.c` | Function designator equality and absence of unreachable undefined symbol |
| `20011126-2.c` | GCSE-affected nested pointer loop: correct return pointer and copied byte |
| `20011128-1.c` | 33-element volatile char array, initialized text and zero-filled tail |
| `20020321-1.c` | Non-inlined function forwarding into a larger FP argument list |
| `20020402-2.c` | Original large register-pressure source with pointer-field readbacks |
| `920202-1.c` | Return path and volatile stack-pop flag assignment |
| `920604-1.c` | Wide signed remainder at small and high-word magnitudes |
| `930526-1.c` | Inlined pointer array into local 175-word integer storage |
| `980506-1.c` | Original goto/null-pointer branch reaches the safe exit |
| `991202-1.c` | Integer doubling-loop exit at x=32, y=64 |
| `991216-4.c` | Nested-loop reversal completes with nine increments |
| `longlong.c` | Wide integer extraction of bit lane 0x4d |

Each case has exactly four `pending` compiler-matrix cells:
PDP-6 GCC native `-O0`, `-O1`, `-O2`, and `-Os` (68 new cells).
The other compiler, CPU, and profile cells are `no_test`, not
`unsupported` or `pass`. The existing semantic runner owns execution
when those cells are eventually selected, and the static source
inventory protects the source hashes and explicit profile choices.

The first registration was GCC-only. The KCC applicability review in
`docs/GCC-C-KCC-CROSS-COMPILER-20261117-v1.md` subsequently enabled
KCC PDP-6 native and base profile cells for all 17 adapted cases.
Most use C89 constructs;
historical GCC-specific `long long`, inline, and `noinline` contracts
are retained only where eliminating them would destroy the regression.
No new C99-only control syntax or host library dependencies are added.

## PDP-10 compatibility analysis

### Width and ABI

The historical tests frequently assume an octet equals eight bits.
PDP-10 C uses 9-bit addressable `char`, 18-bit `short`, and 36-bit
`int`/`long` in the current target. KCC and GCC's normalized `long long`
ABI has **71 value bits** represented in two 36-bit machine words.
In `20000523-1.c`, for example,
`sizeof(long long) < 64` is an **invalid bit-width test**: 8 C bytes
hold the two-word wide representation, not eight octets; the value has
71 bits, not 72 independent bits. The adapted source checks the 55-bit shift
and nonzero quotient directly. The original `20000314-2.c` bit-34
constant and `20000402-1.c` wide division remain representable.

The historical `longlong.c` masks and shifts only lanes below bit 64,
so its expected low eight-bit result remains valid in the normalized
71-bit value. The ABI-forwarding case `20020321-1.c` uses exactly
representable floating constants, **not** IEEE rounding, NaN or infinity.

### Sources not activated

Ten cases are explicitly deferred. Examples: `20000121-1.c` calls an
empty function without an observable check; `920410-1.c` requires
40,000 automatic integer words; `921208-2.c` allocates 100,000 floats;
`920501-9.c` formats 64-bit values as two 32-bit words using hosted
`sprintf`; `930719-1.c` returns an uninitialized automatic value;
`920721-2.c` and `920929-1.c` have unverified GNU-VLA allocation
oracles; and the IEEE rounding cases `ieee/20001122-1.c` and
`ieee/920518-1.c` need independent native F/D-format expectations.

Twenty-three cases have incompatible original requirements and are
classified `inapplicable`, not run as vacuous successes. Most are IEEE
tests requiring NaNs, infinities, signed zero, 24-bit significands, or
binary32/binary64 layout. Others require IRIX semaphores, the H8300
instruction encoding, IA-64 relocations, privileged PDP-10 bootstrap
hardware, or Unix `mmap(MAP_FIXED)` around an assumed 32-bit virtual
address. Reducing these sources to ordinary arithmetic would **replace**
the original assertions rather than integrate them.

## Next batch

The current ledger now records 50 batch-01 decisions, alongside the
24 earlier individually reviewed decisions. Exactly **605 original
sources still lack assertion-level review** (52 same-name candidates
and 553 other sources). The next 50 should be selected from that
unresolved queue, without redoing or silently promoting this batch.
