# PDP10 P1: completion of all ten Batch 2 source obligations (v1)

Date: 2026-11-19. The first five source closures were previously
recorded in `PDP10-P1-BATCH2-FIRST-20261119-v1.md`. This report
covers the other five original source identities in the immutable
59-source six-batch workplan. It is **P1 test construction**, not a
claim that GNU extensions, compiler output, or simulator execution
are correct in every profile.

## Final five source admissions

| Original imported source | Exact registered evidence | P1 state |
| --- | --- | --- |
| `nestfunc-3.c` | `pdp10-nestfunc-captured-sum-v1.c` (GCC 4 normal cells) | **covered** |
| `20010122-1.c` | `pdp10-return-address-depth-v1.c` (GCC 4 normal cells) | **covered** |
| `bf-sign-2.c` | `pdp10-bitfield-36bit-promotions-v1.c` (previous six), `pdp10-gnu-wide-bitfield-promotions-v1.c` (GCC 4) | **covered** |
| `eeprof-1.c` | The **unchanged original** with genuine `-finstrument-functions -D__pdp10__` (GCC 4 specialized, audited cells) | **covered** |
| `991228-1.c` | `pdp10-dec-double-signbit-v1.c` (KCC/GCC 6), `pdp10-gnu-dformat-initializer-v1.c` (GCC 4), `pdp10-gnu-dec-signbit-function-v1.c` (GCC 4) | **covered** |

A feature unsupported by KCC is not called a KCC PASS, and a failing
GCC regression is still a useful completed test construction task.
The 67 original upstream files and their source hashes are unchanged.

## Exact PDP-6 outcomes

The **26 newly run normal compiler-matrix cells** contain:

- **17 guest PASS** (including all four GCC unsigned long-long bitfield
  profiles and all four GNU global D-format union initializer profiles)
- **6 readable guest assertion failures**: GCC `nestfunc` O0 (sum),
  GCC `__builtin_return_address` O0/O1/O2/Os (depth-zero result
  equality), and KCC optimized native D-format continuation signbit
- **2 SIMH wall timeouts**, GCC `nestfunc` O2/Os, with *no readable*
  exit/checkpoint. GCC `nestfunc` O1 genuinely PASSES
- **1 GCC compiler ICE** at `-O0` for the source-preserving GNU
  local designated-union `signbit(double)` form; its O1/O2/Os cells PASS

The four separately executed **real instrumentation** profiles are
also all PASS, making **30 source/profile evidence records** in the
new archive. They are deliberately specialized rather than silently
running the original without the required `-finstrument-functions`.

### Nested callback original

The source-independent Python arithmetic oracle evaluates the original
`foo -> nest_2 -> nest_1 -> use -> nest_0` callback order and the
capture of the changing `sum`. A bounded 2x2x2 input set produces
**eight callbacks and sum 105**, without the historical 10x10x10
`long` accumulation overflowing signed PDP-10 36-bit arithmetic.
The original full test has signed-overflow undefined behavior under C;
its historical 32-bit result literal is not imposed on a 36-bit `long`.
The companion checks defined original callback semantics. GCC O1 PASS
and O0 real arithmetic assertion failure are separately recorded.

### Frame-depth and alloca original

`__builtin_return_address(0)` and `__builtin_return_address(1)`
are checked through four groups of three `noinline` call paths,
including runtime `__builtin_alloca(4)` and a void-callee path
saving the observed address through an external-state location.
The original returns a pointer to a dead automatic buffer in a
`dummy` helper, which the companion does not reproduce. GCC O0/O1/O2/Os
reach real failure checkpoint 1 for the first depth-zero equality;
this does **not** show later assertions pass or fail. KCC lacks this
GCC builtin and is not recorded as supporting it.

### GNU bitfield promotion

Native `int` is 36 bits, so the full unsigned values of both 3- and
35-bit fields can fit in a signed `int`. The new GNU-extension
companion explicitly demands signed promotion, verifies subtraction
from zero and both maximum-field readbacks. GCC O0/O1/O2/Os PASS.
KCC GNU `unsigned long long` bitfield extension remains unsupported;
the separate standard 36-bit `int` field regression continues to
pass all six KCC/GCC profiles.

### Correct function instrumentation options

The original source has explicit `__pdp10__` short-symbol aliases for
`__cyg_profile_func_enter` and `__cyg_profile_func_exit`. GCC on this
target emits shortened hook calls `__cpfn`/`__cpfx`; omitting the
source's intended `-D__pdp10__` aliases makes the link fail.
The four real runs compile the **unchanged** original with
`-finstrument-functions -D__pdp10__ -march=pdp6` at O0/O1/O2/Os,
check both generated hook bodies and entry call instructions, then
link and execute against the real PDP-6 CRT/exit/abort support.
All four PASS the original assertions about exact entry/exit counts,
`no_instrument_function` exemptions and last entered/exited functions.
No fake instrumentation callbacks or libc stubs are inserted.

### Non-IEEE native double and compiler ICE

The independently specified DEC D-format sign bit is
`0400000000000` (bit 35), present in *both* 36-bit words of a
negative double. Actual `-0.25`, `+0.25`, `-1.0` and `+1.0` are
checked, alongside a GNU designated negative union initializer.
Five of the six KCC/GCC native D-format profiles PASS; optimized
KCC fails continuation-word sign readback at checkpoint 3.

A separate source preserves the original local designated union
initializer in `signbit(double)` and calls it with both signs so
optimized compilers cannot take an original early exit without
executing the intended assertion. GCC O0 reproduces the same
`instantiate_virtual_regs` compiler ICE as the unchanged upstream
source. GCC O1/O2/Os PASS. This compiler ICE is a high-priority
**P2 repair**, not a P1 test-construction blocker and not a fix.

## Audited evidence and next batch

Source/profile ledger:
`PDP10-P1-BATCH2-FINAL-RESULTS-20261119-v1.tsv`.
Compressed original compiler, assembler, guest and instrumentation
logs: `refs/pdp10-p1-batch2-final-20261119-v1.tar.gz`.
Host verifier: `tools/verify-p1-batch2-final-v1.py`. It checks
original SHA256s, normal matrix admission, source semantics and host
integer reference oracles, **all 30 distinct profile outcomes**, and
archived SHA256. Instrumentation evidence includes the real assembly
with hook callsites and the exact flags used.

Batch 2 is now **10/10 P1-covered**. Across all 67 historical sources,
**28 covered, 6 partial, 33 blocked** leave **39 actionable P1 tasks**.
The original batch assignments are unchanged at **10+10+10+10+10+9**.
Proceed with Batch 3 width/source adaptation and partial original
oracles; AAP architecture correctness remains P3. Compiler and linker
repairs remain P2, keeping their failing regressions visible.
