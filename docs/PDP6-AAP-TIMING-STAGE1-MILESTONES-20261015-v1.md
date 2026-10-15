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
