# AAP APR timing milestones (2026-10-15, v1)

An opt-in diagnostic trace has been added to the AAP APR pulse callback
functions `it0` and `et0a`, using the previously implemented logical
relative-pulse-delay clock. Enable with `PDP6_AAP_TIMING_TRACE_V1=1`.

Trace syntax is `AAP_TIMING_V1 NAME tick=N pc=OOOOOO inst=OOO` where
`NAME` is `IT0` or `ET0A`. Tick is the accumulated scheduler-delay unit,
**not nanoseconds**, and the opcode/PC fields are the emulator's state
at the particular callback. This format is experimental, bounded-memory,
and silent unless enabled. The testkit validates format and monotonicity
using `misc/compat/test-aap-timing-trace-v1.py`.

Source inspection confirms `it0` clears the memory address and begins an
instruction-cycle path; `et0a` acts during the execute phase and can stop
the CPU for certain instructions. They are **not** accepted as a matched
start/end pair for generic instruction durations. In particular, memory
accesses, interrupt cycles, nested execution, and instruction overlap
have not been assigned complete accounting semantics.

No source-verified physical unit for APR pulse `t` was established in
this stage. Existing provisional memory acknowledgment delays are
unchanged. The next task is to correlate these events with F-67
maintenance-manual flowcharts and construct an executing guest scenario
that validates transition ordering. No CPU-time weights are published.

## Guest-execution validation and APR layout fix (2026-10-15)

Initial headless testing with a 256K-word `moby` module caused a
use-after-free diagnostic in `showmem` and shutdown. AddressSanitizer
helped establish that the actual fault was structural: adding
`Apr.pulse_time_v1` *before* `Apr.dev` had moved the embedded `Device`
eight bytes from the start of the APR allocation. Existing registry and
callback paths cast `Device *` directly to `Apr *`, relying on an
offset-zero `dev` member. This corrupted memory-bus pointers and could
affect arbitrary instruction execution. The fix restores `Device dev`
as the first member and keeps the logical clock immediately afterward.

The testkit now checks this invariant using C99 `offsetof(Apr, dev) == 0`
and executes a real guest using the headless AAP emulator and a 256K-word
memory module. The guest deposits `254200000000` at PDP-6 address `001000`
(`JRST 4`, a halt), powers on, and starts at `001000`. Two diagnostic
events were observed in the initial run:

```
AAP_TIMING_V1 IT0 tick=601 pc=001000 inst=000
AAP_TIMING_V1 ET0A tick=1302 pc=001000 inst=254
```

The test validates the presence, syntax and monotonicity of these
milestones, not the exact tick values. The values are uncalibrated and
cannot yet be treated as a PDP-6 instruction duration. No full
instruction-end marker has been established, and the DEC physical timing
unit remains to be verified. The emulator was exercised with
AddressSanitizer after the fix.

## Three-instruction sequence validation (2026-10-15)

The guest test now configures both the PDP-6 fast-memory module and 256K
core memory. Fast memory is essential for accumulator-access operations;
the deliberately minimal earlier halt-only configuration was insufficient
for executing ordinary arithmetic programs.

An additional guest executes `MOVEI 1,1` (octal 201), `ADDI 1,1` (271),
and `JRST 4` (254). The simulator emitted the following strictly ordered
milestones in one observed run:

```
AAP_TIMING_V1 IT0 tick=601 pc=001000 inst=000
AAP_TIMING_V1 ET0A tick=1302 pc=001000 inst=201
AAP_TIMING_V1 IT0 tick=2002 pc=001001 inst=201
AAP_TIMING_V1 ET0A tick=3103 pc=001001 inst=271
AAP_TIMING_V1 IT0 tick=3953 pc=001002 inst=271
AAP_TIMING_V1 ET0A tick=4654 pc=001002 inst=254
```

This validates one `IT0`/`ET0A` pair per instruction *for this particular
straight-line guest*, including PC and opcode progression, not for the
whole PDP-6 instruction set. Regression checks use event order, monotonic
time, opcode and PC; they intentionally do not assert fixed tick deltas.
The sequence also passed under AddressSanitizer with the correct memory
configuration. Interrupts, XCT, indirect indexing, memory contention,
timing calibration, and a generally correct end-of-instruction boundary
remain open research items.
