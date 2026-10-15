# PDP-6 opcode-count profiling (2026-10-15, v1)

SIMH `PDP10/kx10_cpu.c` now exposes the 512-element `CPU OPCOUNT` array
for PDP-6. Each instruction decoded at `no_fetch` increments the matching
opcode's 64-bit counter. This includes XCT target dispatches. Counters
begin at zero in a new simulator process; they are not inferred from
`step`'s execution limit.

The host `p10run --opcode-profile --machine pdp6` appends an `examine cpu
OPCOUNT[0-511]` request after execution. Use an instrumented PDP-6 SIMH
binary (for example through `SIMH_PDP6=...`). The SIMH `.out` log then
contains a decimal per-opcode histogram. Running with a SIMH binary lacking
the counters is not supported and must not be treated as valid profile data.

`tools/report-pdp6-opcodes-v1.py SIMH_OUTPUT` totals the counters and maps
supported opcode classes to fast/slow **illustrative** timings from Digital
Equipment Corporation's *PDP-6 Brochure*, F-61 (1964), Table 2:
https://bitsavers.trailing-edge.com/pdf/dec/pdp6/brochures/F-61_PDP-6_Brochure_196402.pdf

**Do not interpret the partial time sums as elapsed time.** DEC explicitly
warns that the table is not adequate for computing program runtime;
addressing, indexing, memory and operand-dependent costs are omitted.
Unsupported instruction classes remain unclassified, not assigned guesses.

Observed GCC `-O0` UTF-9 boundary-run profile:

- 5,460,939 opcode dispatches
- 4,096,847 dispatches (75.02%) in currently timed classes
- 1,364,092 dispatches unclassified
- 9.8313–15.8430 seconds partial class-timing sum, **not** total CPU time
- Most common: AOBJN (octal 253), JRST (254), ADDI (271), ADDM (272)

Profiling integration has not yet established cycle-exact instruction
timing or memory stalls. The counter is intended for hotspot identification,
not cycle-perfect hardware simulation.
