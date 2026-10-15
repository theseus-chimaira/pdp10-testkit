# PDP-6 historical-timing calibration plan (2026-10-15, v1)

**Status: design only.** No timing-calibration implementation or validated
CPU-time model is claimed by this document. All experiments and regression
tests belong in `pdp10-testkit`; production documentation in `pdp10-doc`
should be updated only after the work is complete.

## Objective and scope

Use the pulse-level `pdp6-aap` emulator as a *calibration reference* for a
PDP-6 instruction-cost model. Retain instrumented SIMH as the fast execution
and correctness engine. Preserve exact opcode dispatch counts alongside
separate, explicitly approximate time estimates. Do not change DAIMOS's
native SIXBIT/S6REC filesystem format or UTF-9 conversion policy.

Neither emulator constitutes a hardware measurement. All published timing
results must state their model, provenance, emulator revision, memory
configuration, and uncertainty. Never call simulated time actual hardware
elapsed time.

## Baseline established

- SIMH PDP-6 exposes `CPU OPCOUNT[0-511]` and `p10run --opcode-profile`.
- The general semantic testkit matrix optionally emits complete per-cell
  `opcode-profile-v1.json` with `P10_SWEEP_PROFILE=1`; only passing execution
  cells receive profiles.
- `tools/compare-pdp6-profiles-v1.py` can compare exact dispatch counts;
  weighted comparisons require matching full-coverage external weight tables.
- No validated opcode timing table currently exists. Previously published
  provisional timing sums have been withdrawn.

## Stage 1 — Audit the pulse-time model

1. Identify the simulator's scheduler time unit by following `emu/emu.c`
   task scheduling, `emu/apr.c` pulse-list progression, `emu/mem.c` memory
   cycles, and their references in the DEC PDP-6 maintenance manuals.
2. Distinguish scheduled pulse delays from host thread scheduling, wall
   clock, device servicing, and emulated processor time. Record the
   relationship, if any, between delay constants and physical microseconds.
3. Identify instruction-entry and completion events in the APR circuitry.
   Handle XCT, indirect/indexed addressing, jumps, faults, interrupts,
   and asynchronous I/O explicitly; do not infer instruction boundaries
   merely from host loop iterations or recurring timer callbacks.
4. Record the model's known approximations and whether its timing can be
   corroborated with the maintenance manual's pulse diagrams.

**Gate:** do not calculate microseconds until the time unit and boundaries
are demonstrated with traceable source/manual evidence.

## Stage 2 — Nonintrusive emulator instrumentation

1. Introduce an opt-in, versioned tracing interface in `pdp6-aap` that
   emits simulation tick, instruction PC/opcode, start and completion, and
   timing-affecting metadata where the model exposes it.
2. Use bounded memory (prefer streaming records or aggregate counters),
   avoid changing pulse/event scheduling order, and keep profiling disabled
   by default. Instrumentation must not alter execution results.
3. Make counters reproducible across resets/runs, detect overflow, and
   explicitly classify interrupted/aborted or otherwise incomplete
   instructions. Preserve attributable memory wait times if available.
4. Version the trace schema; include emulator git revision and machine
   configuration. Do not silently fold unknown cases into opcode averages.

**Gate:** identical guest workloads must produce identical guest results
with profiling on and off; deterministic traces must reproduce.

## Stage 3 — Controlled instruction measurements

1. Build a minimal PDP-6-compatible self-terminating benchmark harness,
   starting with `AOBJN` (253 octal), `JRST` (254), `ADDI` (271), and
   `ADDM` (272), the dominant opcodes in the UTF-9 test profile.
2. Sweep accumulator vs core operands, address classes, memory placement,
   indexing, indirect addressing, taken/not-taken branches, loop counts,
   and relevant operand values. Include fast/core memory variations where
   the emulator supports them.
3. Establish measurement overhead with empty/control sequences, distinguish
   warm-up/startup from the measured interval, and check repeatability.
4. Cross-check representative pulse paths and time intervals against the
   DEC maintenance manuals. Record discrepancies rather than fitting
   arbitrary corrections to expected values.
5. Exercise additional opcodes in descending measured SIMH frequency,
   focusing first on those needed for useful coverage of real workloads.

**Gate:** timing records must carry reproducible test inputs, conditions,
confidence/uncertainty, and provenance. A single average per opcode is
insufficient if timing varies materially with address or control flow.

## Stage 4 — Testkit cost model and validation

1. Store calibration fixtures and validation programs in `pdp10-testkit`;
   keep instrumentation source changes in the `pdp6-aap` repository.
2. Provide a machine-readable versioned cost model with explicit units and
   documented defaults. If only opcode-level data is available, publish
   fast/slow or scenario-specific ranges rather than spurious precision.
3. Apply costs to SIMH `opcode-profile-v1.json`, reporting opcode coverage,
   unknowns, estimated total or partial cost, and the uncertainty assumptions.
   Refuse a full weighted total when executed instructions are unmodeled.
4. Add baseline/candidate matrix aggregation for identical passing tests,
   with exact dispatch deltas separately from approximate cost deltas.
   Report per-test regressions; do not hide them behind a net aggregate.
5. Regression-test trace parsing, pulse-unit conversion, overflow,
   missing timing data, differing configurations, and performance gates.

**Gate:** do not use weighted cost to automatically accept optimizations
until coverage and matching configurations are checked. Instruction-count
comparison remains the independent fallback.

## Stage 5 — Acceptance and closeout

- A repeatable benchmark demonstrates pulse-derived timing on a documented
  PDP-6 configuration without affecting program execution.
- Instruction timing inputs are traceable to `pdp6-aap` code plus relevant
  DEC documentation; known disagreements and limitations are explicit.
- The testkit produces versioned profiles and comparisons with measured
  dispatches and calibrated, clearly approximate performance metrics.
- All new tests live in `pdp10-testkit`, all code changes pass tests, and
  affected repositories are committed and pushed with Theseus identity.
- Only after validation, update final-state documentation in `pdp10-doc`
  and the project TODO/status references.

## Immediate next action

Start Stage 1 by examining `emu/apr.c` (`pulse`, `stepone`, `aprcycle`),
`emu/emu.c` (`simthread`), and `emu/mem.c`, then write down the verified
tick-to-time relationship and APR instruction boundary events. Do **not**
begin by installing guessed per-opcode timing constants.
