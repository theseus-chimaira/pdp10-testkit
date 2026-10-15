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

`tools/report-pdp6-opcodes-v1.py SIMH_OUTPUT` totals the counters and lists
the most frequently dispatched opcodes. DEC's *PDP-6 Brochure*, F-61 (1964):
https://bitsavers.trailing-edge.com/pdf/dec/pdp6/brochures/F-61_PDP-6_Brochure_196402.pdf

**Correction (2026-10-15):** The earlier partial 9.83–15.84-second timing
sum was derived from unaudited class-wide approximations, *not* verified
PDP-6 instruction timing values. The reporter no longer emits these
figures. The brochure's memory-system discussion confirms that timing
depends on memory configuration and access overlap; a verified per-opcode
timing table is still required for weighted estimates.

Observed GCC `-O0` UTF-9 boundary-run profile:

- 5,460,939 opcode dispatches
- Opcode-weighted CPU time: unmeasured; prior partial estimate withdrawn
- Most common: AOBJN (octal 253), JRST (254), ADDI (271), ADDM (272)

Profiling integration has not yet established cycle-exact instruction
timing or memory stalls. The counter is intended for hotspot identification,
not cycle-perfect hardware simulation.
