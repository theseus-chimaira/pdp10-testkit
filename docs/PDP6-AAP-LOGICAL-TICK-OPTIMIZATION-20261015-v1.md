# PDP-6 AAP logical ticks for optimization (2026-10-15, v1)

## Decision

Historical nanosecond/microsecond calibration is **not a prerequisite** to
optimization. Within an unchanged AAP model, configuration and workload,
logical pulse-delay ticks are a relative machine-cost proxy. The simulator
is not verified real PDP-6 hardware; timings must not be labeled seconds.
SIMH's exact executed-opcode histogram remains an independent comparison
metric and correctness remains the prerequisite for accepting improvements.

## Measurement boundary

The initial diagnostic trace provides `IT0` instruction-cycle entry and
`ET0A` execution-phase milestones. Neither `ET0A` nor the interval
`IT0` to `ET0A` proves complete instruction duration. For consecutively
paired, monotonic straight-line traces, measure

`instruction_cost_i = IT0_tick_(i+1) - IT0_tick_i`.

The interval includes the intervening execution and the transition to
the next instruction, but its attribution remains provisional on unusual
flows. The final instruction is explicitly **unmeasured** without a later
IT0 boundary; never fill it from an estimated `ET0A` difference. The
strict `tools/aap-tick-cost-v1.py` produces versioned JSON and rejects
unsupported or malformed milestone ordering rather than guessing.

For comparable profiles, supply `--workload-id` and `--model-id` to the
extractor. The latter should identify the AAP git revision and memory
configuration. `tools/compare-aap-tick-cost-v1.py BASELINE.json
CANDIDATE.json` compares the sum of complete intervals and fails on a cost
increase by default; `--max-regression-pct N` provides an explicit tolerance.
The comparator refuses mismatched identifiers, incomplete accounting, or
inconsistent data. Identifiers do not themselves establish correctness or
workload equivalence: these must be tested independently first.

The validated MOVEI/ADDI/JRST halt guest provides two complete intervals:
MOVEI 1,401 logical ticks and ADDI 1,951 logical ticks in the observed
run. The terminating JRST has no next IT0 and is excluded from the total.
These are example-model values, **not historical microseconds or universal
per-opcode constants**.

## Integration and acceptance gates

1. Maintain repeatable, passing guest and correctness tests in the testkit.
2. Validate branches, taken/not-taken conditions, indirect/indexed memory,
   `XCT`, interrupts and more complex opcode families before attempting
   general per-opcode cost tables. Measure under controlled configurations.
3. Require common emulator revision/configuration and identical test inputs
   for baseline/candidate comparisons. Report raw instruction counts,
   modeled tick costs, and unmeasured coverage separately.
4. Do not use tick sums as a performance gate when incomplete instruction
   boundaries or mismatched workloads would make comparisons misleading.
5. Keep physical-time calibration as optional future research. Any cost
   model derived from traces must record its origin and uncertainty.

**Current state:** strict interval extraction, executing guest regression,
and model-matched tick-cost comparison are integrated. Branch, XCT and
indirect-flow validation, comprehensive opcode calibration, and matrix-wide
weighted optimization are not yet completed.

## Control-flow validation (2026-10-15)

The registered `aap-control-flow-v1` host test compiles the actual headless
AAP emulator and runs three deterministic short PDP-6 guest programs:

- A direct `JRST 1002` skips address 1001, executes `MOVEI 1,1` at 1002,
  then halts at 1003. The three observed IT0/ET0A milestone pairs have
  PCs 1000, 1002 and 1003.
- An indirect `JRST @1010` takes its destination from word 1010 containing
  1002 and follows the same PC sequence. This validates this indirect
  addressing case, not every indexed/indirect combination.
- `XCT 1010`, where 1010 holds `MOVEI 1,1`, emits **two ET0A events** for
  one IT0 at PC 1000: first opcode 256 (XCT), then 201 (MOVEI). The next
  IT0 is at PC 1001 and the terminating JRST follows.

Consequently, the strict IT0/ET0A interval extractor **must reject XCT
traces** until the cost model explicitly represents nested instruction
execution and attributes the combined interval safely. The regression
test confirms this rejection. Direct and indirect JRST traces remain
measurable with the current straight-line pairing rules, but wider
control-flow coverage and machine-time calibration remain open. No
unvalidated opcode-weight table has been generated.
